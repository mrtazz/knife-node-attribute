require 'chef/knife'


ATTRIBUTE_CLASSES = [:normal, :default, :override]

module KnifeAttribute

  module Helpers
    def get_node(name)

      puts "Looking for an fqdn of #{name} or name of #{name}"

      searcher = Chef::Search::Query.new
      result = searcher.search(:node, "fqdn:#{name} OR name:#{name}")

      knife_search = Chef::Knife::Search.new
      node = result.first.first
      if node.nil?
        ui.error "Could not find a node with the fqdn of #{name} or name of #{name}"
        exit 1
      end
      return node
    end


    # helper methods to get attributes from a node
    def get_all_attributes(node)
      {"default" => get_default_attributes(node),
       "normal" => get_normal_attributes(node),
       "override" => get_override_attributes(node)}
    end

    def get_default_attributes(node)
      node.default_attrs
    end

    def get_normal_attributes(node)
      node.normal_attrs
    end

    def get_override_attributes(node)
      node.override_attrs
    end

  end

  class NodeAttributeShow < Chef::Knife
    include KnifeAttribute::Helpers

    banner 'knife node attribute show HOSTNAME [NORMAL|DEFAULT|OVERRIDE] [colon:separated:key]'

    def parse_args
      unless node_name = name_args[0]
        show_usage
        ui.error "You need to specify a node"
        exit 1
      end
      if name_args[1].nil?
        attribute_class = :all
      else
        attribute_class = name_args[1].downcase.to_sym
        # if we passed a valid attribute class, the next one could be an
        # attribute name. If it's invalid, it might be the attribute name
        if ATTRIBUTE_CLASSES.include? attribute_class
          attribute_name = name_args[2] || ""
        else
          attribute_name = attribute_class
          attribute_class = :all
        end
      end

      {:nodename => node_name,
       :class => attribute_class,
       :name => attribute_name.split(":")}
    end


    def run
      args = parse_args
      method = "get_#{args[:class]}_attributes".to_sym

      node = get_node(args[:nodename])
      attribute_hash = self.send(method, node)
      # this eval business is awful, I should probably come up with something
      # smarter
      getter =  args[:name].empty? ? "" : "['#{args[:name].join("']['")}']"
      if args[:name].nil?
        pp attribute_hash
      else
        begin
          pp eval "attribute_hash#{getter}"
        rescue NoMethodError
          ui.error "Key not found"
        end
      end
    end

  end

  class NodeAttributeDelete < Chef::Knife
    include KnifeAttribute::Helpers

    banner 'knife node attribute delete HOSTNAME NORMAL|DEFAULT|OVERRIDE colon:separated:key'

    def parse_args
      unless node_name = name_args[0]
        show_usage
        ui.error "You need to specify a node"
        exit 1
      end
      if name_args[1].nil?
        show_usage
        ui.error "No attribute level given. (e.g. override, normal, default)"
        exit 1
      else
        attribute_class = name_args[1].downcase.to_sym
        # if we passed a valid attribute class, the next one could be an
        # attribute name. If it's invalid, it might be the attribute name
        unless ATTRIBUTE_CLASSES.include? attribute_class
          show_usage
          ui.error "Wrong attribute level given. (e.g. override, normal, default)"
          exit 1
        end
      end

      unless attribute_name = name_args[2]
        show_usage
        ui.error "No attribute name given."
        exit 1
      end

      {:nodename => node_name,
       :class => attribute_class,
       :name => attribute_name.split(":")}
    end

    def run
      args = parse_args
      method = "#{args[:class]}_attrs".to_sym

      node = get_node(args[:nodename])
      # this eval business is awful, I should probably come up with something
      # smarter
      if args[:name].length == 1
        delete_method =  "node.#{method}.delete('#{args[:name].last}')"
      else
        parent_hash = args[:name][0, args[:name].length - 1]
        delete_method =  "node.#{method}['#{parent_hash.join("']['")}'].delete('#{args[:name].last}')"
      end
      begin
        eval delete_method
        node.save
        msg = parent_hash.nil? ? "" : " from parent structure #{parent_hash.join(':')}"
        puts "Key #{args[:name].last}#{msg} deleted."
      rescue StandardError => e
        ui.error "An error occured while trying to delete the node key:"
        puts e.to_s
      end
    end

  end

end

