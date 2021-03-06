package tokentree.walk;

class WalkQuestion {
	public static function walkQuestion(stream:TokenStream, parent:TokenTree) {
		var ternary:Bool = isTernary(parent);
		var question:TokenTree = stream.consumeTokenDef(Question);
		parent.addChild(question);
		if (!ternary) {
			WalkStatement.walkStatement(stream, question);
			return;
		}
		WalkStatement.walkStatement(stream, question);
		var dblDotTok:TokenTree = stream.consumeTokenDef(DblDot);
		question.addChild(dblDotTok);
		WalkStatement.walkStatement(stream, dblDotTok);
	}

	public static function isTernary(parent:TokenTree):Bool {
		var lastChild:TokenTree = parent.getLastChild();
		if (lastChild == null) {
			return switch (parent.tok) {
				case Const(CIdent(_)): true;
				default: false;
			}
		}
		else {
			return switch (lastChild.tok) {
				case Const(_): true;
				case BkOpen: true;
				case BrOpen: true;
				case Binop(OpAdd), Binop(OpSub): true;
				case Kwd(KwdCast): true;
				case Kwd(KwdNew): true;
				case POpen: true;
				case PClose: true;
				default: false;
			}
		}
	}
}