CPP_SOURCES = (1..5).map{|i|"src/cpp/readbytes#{i}.cpp"}
D_SOURCES = (1..7).map{|i|"src/d/readbytes#{i}.d"}

CPP_COMPILER = [{:name=>'g++',:flags=>'-O3'}, {:name=>'llvm-c++',:flags=>'-O5'}]
D_COMPILER = [{:name=>'dmd', :flags=>"-L-ldl -O -release -of"}, {:name=>'ldc2', :flags => "-L-ldl -O3 -release -of"}, {:name=>'gdc', :flags=>'-ldl -O3 -o'}]

run_all = []
desc 'default task'
task :default

CPP_COMPILER.each { |compiler|
  CPP_SOURCES.each { |source|
    output_name = "target/#{compiler[:name]}/#{source}.exe"
    dir_name = File.dirname(output_name)

    desc dir_name
    directory dir_name

    desc output_name
    file output_name => [source, dir_name] { |t|
      sh "#{compiler[:name]} -DV=\\\"#{compiler[:name]}\\\" #{compiler[:flags]} #{source} -o #{t.name} -ldl"
    }

    t = task "run_#{output_name}" => [output_name] { |t|
      sh output_name
    }

    run_all << t.name
    Rake::Task[:default].enhance([output_name])
  }
}

D_COMPILER.each { |compiler|
  D_SOURCES.each { |source|
    output_name = "target/#{compiler[:name]}/#{source}.exe"
    dir_name = File.dirname(output_name)

    desc dir_name
    directory dir_name

    desc output_name
    file output_name => [source, dir_name] { |t|
      sh "#{compiler[:name]} #{compiler[:flags]}#{t.name} #{source}"
    }

    t = task "run_#{output_name}" => [output_name] { |t|
      sh output_name
    }

    run_all << t.name
    Rake::Task[:default].enhance([output_name])
  }
}


Rake::Task[:default].enhance([:run_all])
desc 'run_all'
t = task :run_all
run_all.each do |name|
  t.enhance([name])
end

