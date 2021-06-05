load("regexp.star", "regexp")
load("assert.star", "assert")

# bad regular expression
assert.fails(lambda: regexp.compile("a(b"), "error parsing regexp")
# regular expression with the forbidden byte-oriented feature
assert.fails(lambda: regexp.compile(".\\C+"), "not supported")
assert.fails(lambda: regexp.compile('.\\C+'), "not supported")
assert.fails(lambda: regexp.compile(""".\\C+"""), "not supported")

re_abs = regexp.compile("ab+")
re_ax = regexp.compile("a.")
re_with_sub_matches = regexp.compile("a(x*)b(y|z)c")
re_axsb = regexp.compile("a(x*)b")
re_a = regexp.compile("a")
re_zs = regexp.compile("z+")
re_3no = regexp.compile('^\\d{3}$')

# matches
assert.true(re_3no.matches("123"))
assert.true(not re_3no.matches("1234"))
assert.true(not re_3no.matches("12a"))
assert.true(re_abs.matches("ab"))
assert.true(re_abs.matches("abbbb"))
assert.true(re_abs.matches("cab"))
assert.true(not re_abs.matches("a"))
assert.true(not re_abs.matches("ca"))
assert.true(not re_abs.matches("ba"))

# find
assert.eq("ab", re_abs.find("ab"))
assert.eq("abbbb", re_abs.find("abbbb"))
assert.eq("ab", re_abs.find("cab"))
assert.eq("", re_abs.find("a"))
assert.eq("", re_abs.find("ca"))
assert.eq("", re_abs.find("ba"))

# find_all
assert.eq(("ar", "an", "al"), re_ax.find_all("paranormal"))
assert.eq(("ar", "an", "al"), re_ax.find_all("paranormal", -1))
assert.eq(("ar", "an", "al"), re_ax.find_all("paranormal", -10))
assert.eq(("ar", "an", "al"), re_ax.find_all("paranormal", 20))
assert.eq(("ar", "an"), re_ax.find_all("paranormal", 2))
assert.eq(("ar", ), re_ax.find_all("paranormal", 1))
assert.eq((), re_ax.find_all("paranormal", 0))
assert.eq(("aa", ), re_ax.find_all("graal"))
assert.eq((), re_ax.find_all("none"))

# find_submatches
assert.eq(("axxxbyc", "xxx", "y"), re_with_sub_matches.find_submatches("-axxxbyc-"))
assert.eq(("abzc", "", "z"), re_with_sub_matches.find_submatches("-abzc-"))
assert.eq((), re_with_sub_matches.find_submatches("none"))

# replace_all with unexpected type
assert.fails(lambda: re_axsb.replace_all("-ab-axxb-", 12), "got int")

# replace_all with string
assert.eq("-T-T-", re_axsb.replace_all("-ab-axxb-", "T"))
assert.eq("--xx-", re_axsb.replace_all("-ab-axxb-", "$1"))
assert.eq("---", re_axsb.replace_all("-ab-axxb-", "$1W"))
assert.eq("-W-xxW-", re_axsb.replace_all("-ab-axxb-", "${1}W"))
assert.eq("none", re_axsb.replace_all("none", "X"))

def toUpperCase(src):
  return src.upper()

# replace_all with function
assert.eq("cABcAXXBc", re_axsb.replace_all("cabcaxxbc", toUpperCase))
assert.eq("cABcAXXBc", re_axsb.replace_all("cabcaxxbc", lambda src: src.upper()))
assert.eq("cabcaxxbc", re_axsb.replace_all("cabcaxxbc", lambda src: src.none))
assert.eq("cabcaxxbc", re_axsb.replace_all("cabcaxxbc", lambda src: 1))

# split
assert.eq(("b", "n", "n", ""), re_a.split("banana"))
assert.eq(("b", "n", "n", ""), re_a.split("banana", -1))
assert.eq(("b", "n", "n", ""), re_a.split("banana", -10))
assert.eq((), re_a.split("banana", 0))
assert.eq(("banana", ), re_a.split("banana", 1))
assert.eq(("b", "nana"), re_a.split("banana", 2))
assert.eq(("pi", "a"), re_zs.split("pizza"))
assert.eq(("pi", "a"), re_zs.split("pizza", -1))
assert.eq(("pi", "a"), re_zs.split("pizza", -10))
assert.eq((), re_zs.split("pizza", 0))
assert.eq(("pizza", ), re_zs.split("pizza", 1))
assert.eq(("pi", "a"), re_zs.split("pizza", 2))
assert.eq(("pi", "a"), re_zs.split("pizza", 20))
