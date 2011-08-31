CPP_SOURCES = (1..5).map{|i|"src/cpp/readbytes#{i}.cpp"}
D_SOURCES = (1..7).map{|i|"src/d/readbytes#{i}.d"}

CPP_COMPILER = ['g++', 'llvm-c++']
D_COMPILER = [{:name=>'dmd', :flags=>"-O -release"}, {:name=>'ldc2', :flags => "-O5 -release"}]

run_all = []
desc 'default task'
task :default

CPP_COMPILER.each { |compiler|
  CPP_SOURCES.each { |source|
    output_name = "target/#{compiler}/#{source}.exe"
    dir_name = File.dirname(output_name)

    desc dir_name
    directory dir_name

    desc output_name
    file output_name => [source, dir_name] { |t|
      sh "#{compiler} -DV=\\\"#{compiler}\\\" -O3 #{source} -o #{t.name} -ldl"
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
      sh "#{compiler[:name]} #{compiler[:flags]} -of#{t.name} #{source} -L-ldl"
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

