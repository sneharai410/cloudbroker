require 'jar_dependencies'
JBUNDLER_LOCAL_REPO = Jars.home
JBUNDLER_JRUBY_CLASSPATH = [Dir["#{Rails.root}/lib/java/*.jar"]]
JBUNDLER_JRUBY_CLASSPATH.freeze
JBUNDLER_TEST_CLASSPATH = [Dir["#{Rails.root}/lib/java/*.jar"]]
JBUNDLER_TEST_CLASSPATH.freeze
JBUNDLER_CLASSPATH = [Dir["#{Rails.root}/lib/java/*.jar"]]
JBUNDLER_CLASSPATH.freeze
