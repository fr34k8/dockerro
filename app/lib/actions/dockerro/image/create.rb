#
# Copyright 2014 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

module Actions
  module Dockerro
    module Image
      class Create < Actions::EntryAction
        include Actions::Base::Polling
        include ::Dynflow::Action::Cancellable

        input_format do
          param :container_id
          param :compute_resource_id
        end
        
        def plan(builder_image, build_config, compute_resource_id)
          # create container
          config = {
            "BUILD_JSON" => JSON.dump(build_config)
          }
          container = plan_action(::Actions::Dockerro::Container::Create, config)
          # run it and wait for it to finish
          plan_action(::Actions::Dockerro::Container::Run,
                      :container_id => container.output[:uuid],
                      :compute_resource_id => compute_resource_id)
          # [delete container]
        end

        def humanized_name
          _("Create")
        end
      end
    end
  end
end
