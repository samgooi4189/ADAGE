namespace :seed_data do
  desc 'Creates fake data from a fake game so we can test data tools locally'
  task :create => :environment do

    rand = Random.new(Time.now.to_i)

    client_token = ''
    game = Game.where(name: 'Fake Game').first
    if game != nil
      imp = game.implementations.first
      if imp != nil
        client_token = imp.client.app_token
      end
    
    end

    adage_context = {'name' => 'find_a_candy', 'parent_name' => 'find_a_candy'}

    adage_vc =    {
                    'active_units' =>  ['forest', 'find_a_candy'],
                    'level' => 'super awesome level'
                  }
    adage_pc =
                  {
                    'x' => rand.rand(0...100),
                    'y' => rand.rand(0...100),
                    'z' => rand.rand(0...100),
                    'rotx' => rand.rand(0...100),
                    'roty' => rand.rand(0...100),
                    'rotz' => rand.rand(0...100)
                  }

    adage_base = {'gameName' => 'Fake Game',
                 'gameVersion' => client_token,
                 'ADAVersion' => 'drunken_dolphin',
                 'timestamp' => Time.now.to_i,
                 'session_token' => Time.now.to_s,
                 'ada_base_types' => ['ADAGEData', 'ADAGEGameEvent', 'ADAGEPlayerEvent'],
                 'key' => 'FGPlayerEvent',
                 'ADAGEVirtualContext' => adage_vc,
                 'ADAGEPositionalContext' => adage_pc,
                 'user_id' => rand.rand(1..User.all.count)
                  }

    adage_start = {'gameName' => 'Fake Game',
                 'gameVersion' => client_token,
                 'ADAVersion' => 'drunken_dolphin',
                 'timestamp' => Time.now.to_i,
                 'session_token' => Time.now.to_s,
                 'ada_base_types' => ['ADAGEData', 'ADAGEContext', 'ADAGEContextStart'],
                 'key' => 'FGQuestStart',
                 'user_id' => 1,
                 'name' => 'Quest!',
                 'parent_name' => 'Mission',

                  }

    adage_end = {'gameName' => 'Fake Game',
                 'gameVersion' => client_token,
                 'ADAVersion' => 'drunken_dolphin',
                 'timestamp' => Time.now.to_i,
                 'session_token' => Time.now.to_s,
                 'ada_base_types' => ['ADAGEData', 'ADAGEContext', 'ADAGEContextEnd'],
                 'key' => 'FGQuestEnd',
                 'user_id' => 1,
                 'name' => 'Quest!',
                 'parent_name' => 'Mission',
                 'success' => true
                  }



     start_time = Time.now - rand.rand(0..5) * 1.days
     types = [adage_base, adage_start, adage_end]
     quest_names = ['Find the Thing', 'Resuce the Prince', 'slay the dragon']
     success = [true, false, true, false, true, false]
     (0..100).each do |i|
        data = AdaData.with_game("Fake_Game").new(types[rand.rand(0...types.count)])
        data.user_id = rand.rand(1..User.all.count)
        puts 'creating data for ' + data.user_id.to_s
        data.session_token = start_time.to_s
        data.timestamp = (start_time + (1.minute * rand.rand(1..50))).to_i.to_s
        if data.key.include?('FGQuest')
          data.name = quest_names[rand.rand(0...quest_names.count)]
        end

        if data.key.include?('FGQuestEnd')
          data.success = success[rand.rand(0...success.count)]
        end
        data.save
     end

  end
end
