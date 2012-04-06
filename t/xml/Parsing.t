function main[main]()
{
    var core = load_packfile("rosella/core.pbc");
    var(Rosella.initialize_rosella)("test", "xml");
    Rosella.Test.test_vector(
        function(var self, string data) {
            var doc = Rosella.Xml.read_string(data);
            self.assert.not_null(doc);
            self.assert.instance_of(doc, class Rosella.Xml.Document);
        }, __test_data()
    );
}

function __test_data() { return {
    // Tests for basic tag structures
    "Basic" : "<foo><bar><baz></baz></bar></foo>",
    "contained tag" : "<foo><bar><baz/></bar></foo>",
    "one tag" : "<foo></foo>",
    "one contained tag" : "<foo/>",

    // Tests for headers and frontmatter
    "xml header" : "<?xml version='1.0'?><foo></foo>",
    "dtd header" : "<!DOCTYPE foo SYSTEM 'foo.dtd'><foo></foo>",
    "two headers" : "<?xml version='1.0'?><!DOCTYPE foo SYSTEM 'foo.dtd'><foo></foo>",
    "comments between headers" : "<!--test--><?xml version='1.0'?><!--test2--><!DOCTYPE foo SYSTEM 'foo.dtd'><!--test3--><foo></foo>",

    // Tests for whitespace
    "whitespace" : <<:
<foo>
    <   bar>
        <   baz  />
    </bar   >
</foo  >


:>>
,

    // Tests for namespaces
    "namespaces" : "<foo:bar></foo:bar>",

    // Tests for comments
    "comments" : "<!--test-->",
    "comments with dashes" : "<!-- - test -- test2 -> -->",

    // Tests for various attribute syntaxes
    "attribute" : "<foo bar='baz'></foo>",
    "attribute unquoted" : "<foo bar=baz></foo>",
    "attribute boolean" : "<foo bar></foo>",
    "attribute quoted escapes" : "<foo bar='blahblah\\'blahblah'></foo>"
};}