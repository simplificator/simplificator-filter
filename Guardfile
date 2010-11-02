# A sample Guardfile
# More info at http://github.com/guard/guard#readme

guard 'test' do
  watch('^test/(.*)_test.rb')
  watch('^lib/(.*)\.rb')   { |m| "test/#{m[1]}_test.rb" }
  watch('^test/test_helper.rb')  { "test" }
end
