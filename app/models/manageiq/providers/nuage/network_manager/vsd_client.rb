require 'rest-client'
require 'rubygems'
require 'json'
module ManageIQ::Providers
  class Nuage::NetworkManager::VsdClient
    include Vmdb::Logging
    def initialize(server, user, password)
      @server = server
      @user = user
      @password = password
      @rest_call = Rest.new(server, user, password)
      connected, data = @rest_call.login
      if connected
        @enterprise_id = data
        return
      end
      _log.error('VSD Authentication failed')
    end

    def get_enterprises
      response = @rest_call.get(@server + '/enterprises')
      if response.code == 200
        if response.body == ''
          _log.warn('No enterprises present')
          return
        end
        return JSON.parse(response.body)
      end
      _log.error('Error in connection for server ' + @server.to_s + ' ' + response.code.to_s)
    end

    def get_enterprise(id)
      response = @rest_call.get(@server + '/enterprises/' + id)
      if response.code == 200
        if response.body == ''
          _log.warn("Enterprise with ID not found: #{id}")
          return
        end
        return JSON.parse(response.body).first
      end
      _log.error('Error in connection for server ' + @server.to_s + ' ' + response.code.to_s)
    end

    def get_domains
      response = @rest_call.get(@server + '/domains')
      if response.code == 200
        if response.body == ''
          _log.warn('No domains present')
          return
        end
        return JSON.parse(response.body)
      end
      _log.error('Error in connection ' + response.code.to_s)
    end

    def get_domain(id)
      response = @rest_call.get(@server + '/domains/' + id)
      if response.code == 200
        if response.body == ''
          _log.warn("Domain with ID not found: #{id}")
          return
        end
        return JSON.parse(response.body).first
      end
      _log.error('Error in connection ' + response.code.to_s)
    end

    def get_domains_for_enterprise(enterprise_id)
      response = @rest_call.get(@server + '/enterprises/' + enterprise_id + '/domains')
      if response.code == 200
        if response.body == ''
          _log.warn("Domains for enterprise with ID not found: #{enterprise_id}")
          return
        end
        return JSON.parse(response.body)
      end
      _log.error('Error in connection ' + response.code.to_s)
    end

    def get_zones
      @rest_call.append_headers("X-Nuage-FilterType", "predicate")
      @rest_call.append_headers("X-Nuage-Filter", "name ISNOT 'BackHaulZone'")
      response = @rest_call.get(@server + '/zones')
      if response.code == 200
        if response.body == ''
          _log.warn('No zones present')
          return
        end
        return JSON.parse(response.body)
      end
      _log.error('Error in connection ' + response.code.to_s)
    end

    def get_zone(id)
      @rest_call.append_headers("X-Nuage-FilterType", "predicate")
      @rest_call.append_headers("X-Nuage-Filter", "name ISNOT 'BackHaulZone'")
      response = @rest_call.get(@server + '/zones/' + id)
      if response.code == 200
        if response.body == ''
          _log.warn("Zone with ID not found: #{id}")
          return
        end
        return JSON.parse(response.body).first
      end
      _log.error('Error in connection ' + response.code.to_s)
    end

    def get_subnets
      @rest_call.append_headers("X-Nuage-FilterType", "predicate")
      @rest_call.append_headers("X-Nuage-Filter", "name ISNOT 'BackHaulSubnet'")
      response = @rest_call.get(@server + '/subnets')
      if response.code == 200
        if response.body == ''
          _log.warn('No subnets present')
          return
        end
        subnets = JSON.parse(response.body)
        return subnets
      end
      _log.error('Error in connection ' + response.code.to_s)
    end

    def get_subnet(id)
      @rest_call.append_headers("X-Nuage-FilterType", "predicate")
      @rest_call.append_headers("X-Nuage-Filter", "name ISNOT 'BackHaulSubnet'")
      response = @rest_call.get(@server + '/subnets/' + id)
      if response.code == 200
        if response.body == ''
          _log.warn("Subnet with ID not found: #{id}")
          return
        end
        return JSON.parse(response.body).first
      end
      _log.error('Error in connection ' + response.code.to_s)
    end

    def get_subnets_for_domain(domain_id)
      @rest_call.append_headers("X-Nuage-FilterType", "predicate")
      @rest_call.append_headers("X-Nuage-Filter", "name ISNOT 'BackHaulSubnet'")
      response = @rest_call.get(@server + '/domains/' + domain_id + '/subnets')
      if response.code == 200
        if response.body == ''
          _log.warn("Subnets for domain with ID not found: #{domain_id}")
          return
        end
        return JSON.parse(response.body)
      end
      _log.error('Error in connection ' + response.code.to_s)
    end

    def get_vports
      response = @rest_call.get(@server + '/vports')
      if response.code == 200
        if response.body == ''
          _log.warn('No vports present')
          return
        end
        return JSON.parse(response.body)
      end
      _log.error('Error in connection ' + response.code.to_s)
    end

    def get_vms
      response = @rest_call.get(@server + '/vms')
      if response.code == 200
        if response.body == ''
          _log.warn('No VM present')
          return
        end
        return JSON.parse(response.body)
      end
      _log.error('Error in connection ' + response.code.to_s)
    end

    def get_policy_groups
      response = @rest_call.get(@server + '/policygroups')
      if response.code == 200
        if response.body == ''
          _log.warn('No policy Group present')
          return
        end
        return JSON.parse(response.body)
      end
      _log.error('Error in connection ' + response.code.to_s)
    end

    def get_policy_group(id)
      response = @rest_call.get(@server + '/policygroups/' + id)
      if response.code == 200
        if response.body == ''
          _log.warn("PolicyGroup with ID not found: #{id}")
          return
        end
        return JSON.parse(response.body).first
      end
      _log.error('Error in connection ' + response.code.to_s)
    end

    def get_policy_groups_for_domain(domain_id)
      response = @rest_call.get(@server + '/domains/' + domain_id + '/policygroups')
      if response.code == 200
        if response.body == ''
          _log.warn("Domain with ID not found: #{domain_id}")
          return
        end
        return JSON.parse(response.body)
      end
      _log.error('Error in connection ' + response.code.to_s)
    end
  end
end
