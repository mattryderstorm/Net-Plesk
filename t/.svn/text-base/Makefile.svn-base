all:
	perl -MTest::Harness -e '$$Test::Harness::verbose=0; runtests @ARGV;' add_tests/*.t set_tests/*.t get_tests/*.t del_tests/*.t
verbose:
	perl -MTest::Harness -e '$$Test::Harness::verbose=0; runtests @ARGV;' add_tests/*.t set_tests/*.t get_tests/*.t del_tests/*.t

