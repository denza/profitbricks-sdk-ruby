module ProfitBricks
  # Volume class
  class Volume < ProfitBricks::Model

    # Delete the volume.
    def delete
      ProfitBricks.request(
        method: :delete,
        path: "/datacenters/#{self.datacenterId}/volumes/#{self.id}",
        expects: 202
      )
    end

    # Update the volume.
    def update(options = {})
      response = ProfitBricks.request(
        method: :patch,
        path: "/datacenters/#{self.datacenterId}/volumes/#{self.id}",
        expects: 202,
        body: options.to_json
      )
      if response
        @properties = @properties.merge(response['properties'])
      end
      self
    end

    # Attach volume to server.
    def attach(server_id)
      response = ProfitBricks.request(
        method: :post,
        path: "/datacenters/#{self.datacenterId}/servers/#{server_id}/volumes",
        expects: 202,
        body: { id: self.id }.to_json
      )
      self
    end

    # Detach volume from server.
    def detach(server_id)
      ProfitBricks.request(
        method: :delete,
        path: "/datacenters/#{self.datacenterId}/servers/#{server_id}/volumes/#{self.id}",
        expects: 202
      )
    end

    # Create volume snapshot.
    #
    # ==== Parameters
    # * +options+<Hash>:
    #   - +name+<String> - *Optional*, name of the snapshot
    #   - +description+<String> - *Optional*, description of the snapshot
    #
    # ==== Returns
    # * +id+<String> - Universally unique identifer of resource
    # * +type+<String> - Resource type
    # * +href+<String> - Resource URL representation
    # * +metadata+<Hash>:
    #   - +lastModifiedDate+
    #   - +lastModifiedBy+
    #   - +createdDate+
    #   - +createdBy+
    #   - +state+
    #   - +etag+
    # * +properties+<Hash>:
    #   - +name+<Integer>
    #   - +description+<Array>
    #   - +location+<String>
    #   - +cpuHotPlug+<Boolean>
    #   - +cpuHotUnPlug+<Boolean>
    #   - +ramHotPlug+<Boolean>
    #   - +ramHotUnPlug+<Boolean>
    #   - +nicHotPlug+<Boolean>
    #   - +nicHotUnPlug+<Boolean>
    #   - +discVirtioHotPlug+<Boolean>
    #   - +discVirtioHotUnPlug+<Boolean>
    #   - +discScsiHotPlug+<Boolean>
    #   - +discScsiHotUnPlug+<Boolean>
    #   - +licenceType+<String>
    #
    def create_snapshot(options = {})
      response = ProfitBricks.request(
        method: :post,
        path: "/datacenters/#{self.datacenterId}/volumes/#{self.id}/create-snapshot",
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
        expects: 202,
        body: URI.encode_www_form(options)
      ) 
      ProfitBricks::Snapshot.new(response)
    end

    # Restore snapshot to volume.
    #
    # ==== Parameters
    # * +snapshot_id+<String>: Universally unique identifer of snapshot resource
    #
    # ==== Returns
    # * +true+<Boolean>
    #
    def restore_snapshot(snapshot_id)
      ProfitBricks.request(
        method: :post,
        path: "/datacenters/#{self.datacenterId}/volumes/#{self.id}/restore-snapshot",
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
        expects: 202,
        body: URI.encode_www_form(snapshotId: snapshot_id)
      ) 
    end

    class << self

      # Create a new volume.
      #
      # ==== Parameters
      # * +options+<Hash>:
      #   - +name+<String> - *Optional*, name of the volume
      #   - +size+<Integer> - *Required*, size of the volume in GB
      #   - +bus+<String> - *Optional*, the bus type of the volume
      #     * +VIRTIO+ - *Default*
      #     * +IDE+
      #   - +image+<String> - *Optional*, image or snapshot ID
      #
      # ==== Returns
      # * +id+<String> - Universally unique identifer of resource
      # * +type+<String> - Resource type
      # * +href+<String> - Resource URL representation
      # * +metadata+<Hash>:
      #   - +lastModifiedDate+
      #   - +lastModifiedBy+
      #   - +createdDate+
      #   - +createdBy+
      #   - +state+
      #   - +etag+
      # * +properties+<Hash>:
      #   - +name+<String>
      #   - +size+<Integer>
      #   - +bus+<String>
      #   - +image+<String>
      #   - +imagePassword+<String>
      #   - +type+<String>
      #   - +licenseType+<String>
      #   - +cpuHotPlug+<Boolean>
      #   - +cpuHotUnPlug+<Boolean>
      #   - +ramHotPlug+<Boolean>
      #   - +ramHotUnPlug+<Boolean>
      #   - +nicHotPlug+<Boolean>
      #   - +nicHotUnPlug+<Boolean>
      #   - +discVirtioHotPlug+<Boolean>
      #   - +discVirtioHotUnPlug+<Boolean>
      #   - +discScsiHotPlug+<Boolean>
      #   - +discScsiHotUnPlug+<Boolean>
      #
      def create(datacenter_id, options = {})
        response = ProfitBricks.request(
          method: :post,
          path: "/datacenters/#{datacenter_id}/volumes",
          expects: 202,
          body: { properties: options }.to_json
        )
        add_parent_identities(response)
        instantiate_objects(response)
      end

      # List all datacenter volumes.
      def list(datacenter_id, server_id = nil)
        if server_id.nil?
          path = "/datacenters/#{datacenter_id}/volumes"
        else
          path = "/datacenters/#{datacenter_id}/servers/#{server_id}/volumes"
        end
        response = ProfitBricks.request(
          method: :get,
          path: path,
          expects: 200
        )
        add_parent_identities(response)
        instantiate_objects(response)
      end

      # Retrieve a datacenter volume.
      def get(datacenter_id, server_id = nil, volume_id)
        if server_id.nil?
          path = "/datacenters/#{datacenter_id}/volumes/#{volume_id}"
        else
          path = "/datacenters/#{datacenter_id}/servers/#{server_id}/volumes/#{volume_id}"
        end
        response = ProfitBricks.request(
          method: :get,
          path: path,
          expects: 200
        )
        add_parent_identities(response)
        instantiate_objects(response)
      end
    end
  end
end
