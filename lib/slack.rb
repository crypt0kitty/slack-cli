#!/usr/bin/env ruby
# frozen_string_literal: true
require_relative 'workspace'
require_relative 'user'
require_relative 'channel'
require 'httparty'
require 'dotenv/load'
require 'awesome_print'
require 'colorize'
require 'table_print'
require 'pry'


def main
  puts "Welcome to the Ada Slack CLI!\n".yellow
  workspace = Workspace.new

  puts "There are #{workspace.users.length} users and #{workspace.channels.length} channels.\n".blue

  exit_loop = false
  until(exit_loop)
    puts 'Please select an option from below:'.magenta
    puts '1. list users'.magenta
    puts '2. list channels'.magenta
    puts '3. select user'.magenta
    puts '4. select channel'.magenta
    puts '5. details'.magenta
    puts '6. send message'.magenta
    puts '7. quit'.magenta
    print 'Choice: '.yellow

    user_answer = gets.chomp.downcase

    case user_answer
    when 'list users', 'users', "1"
      tp workspace.users, 'name','slack_id', 'real_name'
    when 'list channels', 'channels', "2"
      tp workspace.channels, 'name', 'slack_id', 'topic', 'member_count'
    when 'select user', "3"
      puts 'Please enter the Username or Slack ID'
      print 'Select User:'.yellow
      username_or_id = gets.chomp.downcase
      if workspace.select_user(username_or_id)
        puts "Selected User: #{workspace.selected.name}".blue
      else
        puts 'User Not found. Please Try Again'
      end
    when 'select channel', "4"
      puts 'Please enter the Name or Slack ID'
      print 'Select Channel:'.yellow
      name_or_id = gets.chomp.downcase
      if workspace.select_channel(name_or_id)
        puts "Selected Channel: #{workspace.selected.name}".blue
      else
        puts "Channel Not found. Please Try Again"
      end
    when 'details', 'detail', '5'
      if workspace.details
        puts "Here are the details...".light_cyan
      puts workspace.details
      else
        puts 'Please choose a user or channel.'
      end

    when 'send message', 'message', '6'
      message = ""
      if workspace.selected
        while message.empty?
          puts "Please type in the message you would like to send.".light_blue
          print "Message:".yellow
          message = gets.chomp
        end
      else
        puts "Please select a user or a channel"
        next
      end

      begin
        if workspace.send_message(message)
          puts "Your message \"#{message}\" was successfully sent to #{workspace.selected.slack_id}!".light_magenta
        end
      rescue SlackAPIError => error
        puts error.message
      end

    when 'quit', 'q', "7"
      puts 'Thank you for using the Ada Slack. Have a good day!'.blue
      exit_loop = true
    else
      puts "Invalid input, try again!\n".red
    end
  end
end
main if __FILE__ == $PROGRAM_NAME
