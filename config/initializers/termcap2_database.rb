#TERMCAP2 = YAML.load_file(File.join(Rails.root, "config", "termcap2.yml"))[Rails.env.to_s]

file = File.read(Rails.root.join("config", "termcap2.yml"))
yaml = ERB.new(file).result

TERMCAP2 = YAML.load(yaml)[Rails.env.to_s]