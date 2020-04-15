hexo.extend.filter.register("theme_inject", function (injects) {
	injects.comment.file("utteranc-comment", "source/_data/utteranc.swig");
});
