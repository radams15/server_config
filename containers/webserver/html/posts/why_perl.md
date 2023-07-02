Title: Why Perl?
Tags: programming
Published: 30/06/2023

---
# Why Perl?

I've been told by many people now that Perl is an archaic and incomprehensible programming language and that I should write new projects in more popular languages such as Python, JavaScript or even Rust.

Don't get me wrong - other languages have their place. For anything that I want to distribute to others I'd generally choose another language, such as C++ because it can be distributed without a runtime as one big binary. For anything which requires lots of speed I'd choose C.

I could go on but in short I'll use Perl for anything personal which:

- Needs to be written quickly.
- Can run on UNIX like systems (I'm not running Perl on Windows)
- Heavily based around strings (such as web parsing, text processing, etc.) where compiled languages will fall down.

There are many reasons I love Perl, but the main one is just how expressive it can be.

Take the following code in Python that validates an input:

	import re

	email = ''

	while(not re.match(r'.*@.*\.com', email)):
		email = input("Email: ")

	print(email)

Looks fairly straight-forward, just reading an input and validating it by a regex.

But here is the same in Perl:

	my $email;
	do {
		print "Email: ";
	} until(($line = <STDIN>) =~ /.*@.*\.com/);

	print "$line\n";

Whilst some may disagree, this to me seems so much more natural to read, and the inbuilt regex handling is so much better than any compiled language or Python.

## Regex support

Perl is based around the use of regular expressions. They are a first class citizen in the Perl world.

#### If statements

If statements can be used to find whether there is a match to a string, for example:

	my $str = "my name is Geoff";

	if($str =~ /my name is (.*)/g) {
		print "Name: $1\n";
	}

`$1` refers to the first group, `$2` the second and so on.
#### While loops

While loops can be used to repeat for every match, for example:

	my $str = "i 'hope' you have a nice 'day'";
	while($str =~ /'([^']*)'/g) {
		print "Quoted: $1\n";
	}

## Syntactic Sugar

Perl has a lot of syntactic sugar, which when unfamiliar with can cause a bit of trouble, but once one has become accustomed to it it becomes extremely useful.

Here are a few of my favourite keywords:

- `unless(x)` - equal to `if(not x)`
- `until(x)` - equal to `while(not x)`

#### `$_` - The default variable

`$_` is the default variable - in many scenarios this can be used in functions without specifying it.

Take for example the following program to print all the words surrounded by quote marks in a string (this can easily be done in a more concise way but I do it like this to demonstrate the feature):


	my $str = "i 'hope' you have a nice 'day'";

	for my $word (split / /, $str) {
		chomp $word;
		if($word =~ /'[^']*'/g) {
			print "Quoted: $&\n";
		}
	}

But using the default variable it can be rewritten as so:


	my $str = "i 'hope' you have a nice 'day'";

	for (split / /, $str) {
		chomp;
		if(/'[^']*'/g) {
			print "Quoted: $&\n";
		}
	}

So `for`, `chomp` and `if` all assume the default variable is used when another is not specified.

#### `qw`

`qw` is an easy way to specify an array of strings. Whereas one can do the following:

	my @a = ('hello', 'there', 'cat');

We can now use `qw` to make it easier:

	my @a = qw/ hello there cat /;

This is just a nice feature which is fairly easy to pick up.

#### The diamond operator

The diamond operator is complicated in its definition, but I will attempt to explain its behaviour.

Empty diamond:

	while(<>) {
		print "$_\n";
	}

This is the same as saying: 'open the command line arguments as files and read their content line by line, and if there are no arguments then read from STDIN'.

Diamond with a file handle:

	open FH, '<', 'test.txt';

	while(<FH>) {
		print "$_\n";
	}

	close FH;

This reads the file handle line by line. This can also be done with the file handle of STDIN to read a line of text from standard input.