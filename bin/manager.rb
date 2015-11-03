#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'aws-sdk'
require 'json'


# Command line args
program :version, '0.0.1'
program :description, 'Manages deployment in AWS'

global_option '-n', '--stack-name STACK NAME', 'Name for the stack (default: \'aftp\')'
global_option '-r', '--region REGION', 'Region to use (default: \'us-west-2\')'
default_command :create

command :create do |c|
  c.syntax = 'manager create [options]'
  c.summary = 'Creates the CloudFormation stack'
  c.description = ''
  c.option '-k', '--key-name KEY_NAME', 'Key name to use for EC2 hosts'
  c.action do |args, options|
    options.default  :region =>  'us-west-2', :stack_name => 'aftp'
    template = JSON.load(File.read(File.dirname(__FILE__)+'/../cfn-templates/stack.template'))

    cfn = Aws::CloudFormation::Client.new(region: options.region)
    cfn.create_stack({
        stack_name: options.stack_name,
        template_body: template.to_json,
        capabilities: ['CAPABILITY_IAM'],
        parameters: [
          {
              parameter_key: 'KeyName',
              parameter_value: options.key_name
          }
        ]
    })


    print "Waiting for create to complete..."
    in_progress = true
    while in_progress
      resp = cfn.describe_stacks({ stack_name: options.stack_name })

      if !resp || !resp.stacks
        in_progress = false
        print " Failed!\n"
      elsif resp.stacks[0].stack_status == 'CREATE_FAILED'
        in_progress = false
        print " Failed!\n"
      elsif resp.stacks[0].stack_status.start_with? 'ROLLBACK'
        in_progress = false
        print " Rolled Back!\n"
      elsif resp.stacks[0].stack_status == 'CREATE_COMPLETE'
        in_progress = false
        print " Success!\n"
      else
        print "."
        sleep(2)
      end
    end
  end
end

command :delete do |c|
  c.syntax = 'manager delete [options]'
  c.summary = 'Deletes the CloudFormation stack'
  c.description = ''
  c.action do |args, options|
    options.default  :region =>  'us-west-2', :stack_name => 'aftp'

    cfn = Aws::CloudFormation::Client.new(region: options.region)
    cfn.delete_stack({ stack_name: options.stack_name })

    print "Waiting for delete to complete..."
    in_progress = true
    while in_progress

      resp = cfn.describe_stacks({ stack_name: options.stack_name }) rescue nil

      if !resp || !resp.stacks || resp.stacks[0].stack_status == 'DELETE_COMPLETE'
        in_progress = false
        print " Success!\n"
      elsif resp.stacks[0].stack_status == 'DELETE_FAILED'
        in_progress = false
        print " Failed!\n"
      else
        print "."
        sleep(2)
      end

    end
  end
end


