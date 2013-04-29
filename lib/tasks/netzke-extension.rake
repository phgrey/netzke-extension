namespace "netzke-extension" do
  task :hello do
    puts "Hello world"
  end

  task :extjs do
    version = "ext-4.1.1a";
    puts "ExtJS #{version}:"
    download "http://cdn.sencha.io/#{version}-gpl.zip", 'extjs', version
  end

  task :icons do
    puts "FamFamFam Icons"
    sh 'mkdir -p public/images' unless File.exists? 'public/images'
    download 'http://www.famfamfam.com/lab/icons/silk/famfamfam_silk_icons_v013.zip', 'images/icons', 'icons'
  end

  task :all => [:extjs, :icons] do
    puts "All"
  end

  def download url, public_subfolder, dirname_in_arc
    puts "downloading"
    sh "wget #{url}"
    puts "extracting"
    sh 'mkdir -p vendor/assets' unless File.exists? 'vendor/assets'
    sh "unzip -q -d vendor/assets -n #{url.split('/').last}"
    sh "rm -f #{url.split('/').last}"
    puts "createing symlink"
    sh "ln -s #{'../'*public_subfolder.split('/').count}vendor/assets/#{dirname_in_arc} public/#{public_subfolder}"
    puts "done!"
  end

  task :gitignore do
    puts 'Appenging gitignore'
    if File.exists?('.gitignore')
      File.open('.gitignore', 'w') do |f|
        # use "\n" for two lines of text
        f.puts "vendor/assets/ext*\nvendor/assets/icons\npublic/extjs\npublic/images/icons"
      end
      puts('written')
    else
      puts('.gitignore not found')

    end
  end
end