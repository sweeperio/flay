def read_fixture(path)
  File.read(fixture_path(path))
end

def fixture_path(path)
  File.join(File.expand_path("../../fixtures", __FILE__), path)
end
