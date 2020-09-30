from pygments.lexer import RegexLexer
from pygments.token import *

__all__ = ['BirchLexer']

class BirchLexer(RegexLexer):
    name = 'Birch'
    aliases = ['birch']
    filenames = ['*.birch']

    tokens = {
        'root': [
            (r'//.*?$', Comment.Singleline),
            (r'/\*', Comment.Multiline, 'comment'),
            (r'(cpp|hpp)\s*\{\{', Comment.Multiline, 'raw'),
            (r'"', String.Double, 'string'),
            (r'\b(function|program|class|type|operator|let|if|else|for|in|while|do|with|assert|return|factor)\b', Keyword.Declaration),
            (r'\b(parallel|dynamic|abstract|override|final)\b', Keyword.Declaration),
            (r'\b(global|super|this)\b', Name.Builtin.Pseudo),
            (r'<-|->|<~|~>|~|<-\?|\.\.|\?|!|&&|\|\||<|>|<=|>=|==|!=|\+|-|\*|/|=|\.', Operator),
            (r'\\|,|;|:|\(|\)|\[|\]|\{|\}', Punctuation),
            (r'\b([A-Z][A-Za-z0-9]+)\b(?!\()', Keyword.Type),
            (r'\b[A-Za-zαβγδεζηθικλμνξοπρστυφχψωΓΔΘΛΞΠΣΥΦΨΩ][A-Za-z0-9αβγδεζηθικλμνξοπρστυφχψωΓΔΘΛΞΠΣΥΦΨΩ_]*\'*\b(?=\()', Name.Function),
            (r'\b[a-zαβγδεζηθικλμνξοπρστυφχψωΓΔΘΛΞΠΣΥΦΨΩ][A-Za-z0-9αβγδεζηθικλμνξοπρστυφχψωΓΔΘΛΞΠΣΥΦΨΩ_]*\'*\b(?!\()', Name.Variable),
            (r'\b[A-Za-zαβγδεζηθικλμνξοπρστυφχψωΓΔΘΛΞΠΣΥΦΨΩ]\'*\b(?!\()', Name.Variable),
            (r'\b(nil|true|false|_)\b', Number),
            (r'\b[0-9]+[Ee][+-]?[0-9]+\b', Number.Integer),
            (r'\b[0-9]+\\.[0-9]+([Ee][+-]?[0-9]+)?\b', Number.Float),
            (r'\b0[xX][a-fA-F0-9]+\b', Number.Hex),
            (r'\b0[0-9]+\b', Number.Oct),
            (r'\b[0-9]+\b', Number.Integer)
        ],
        'comment': [
            (r'[^*/]', Comment.Multiline),
            (r'\*/', Comment.Multiline, '#pop'),
            (r'[*/]', Comment.Multiline)
        ],
        'raw': [
            (r'[^}]', Comment.Multiline),
            (r'\}\}', Comment.Multiline, '#pop'),
            (r'[}]', Comment.Multiline)
        ],
        'string': [
            (r'[^"]', String.Double),
            (r'\\"', String.Double),
            (r'"', String.Double, '#pop'),
        ]
    }
