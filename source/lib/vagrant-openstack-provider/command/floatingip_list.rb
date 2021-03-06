require 'vagrant-openstack-provider/command/utils'
require 'vagrant-openstack-provider/command/abstract_command'

module VagrantPlugins
  module Openstack
    module Command
      class FloatingIpList < AbstractCommand
        include VagrantPlugins::Openstack::Command::Utils

        def self.synopsis
          I18n.t('vagrant_openstack.command.flaotingip_list_synopsis')
        end
        def cmd(name, argv, env)
          fail Errors::NoArgRequiredForCommand, cmd: name unless argv.size == 0 || argv == ['--']

          floating_ip_pools = env[:openstack_client].nova.get_floating_ip_pools(env)
          floating_ips = env[:openstack_client].nova.get_floating_ips(env)

          rows = []
          floating_ip_pools.each do |floating_ip_pool|
            rows << [floating_ip_pool['name']]
          end
          display_table(env, ['Floating IP pools'], rows)

          rows = []
          floating_ips.each do |floating_ip|
            rows << [floating_ip['id'], floating_ip['ip'], floating_ip['pool'], floating_ip['instance_id']]
          end
          display_table(env, ['Id', 'IP', 'Pool', 'Instance id'], rows)
        end
      end
    end
  end
end
