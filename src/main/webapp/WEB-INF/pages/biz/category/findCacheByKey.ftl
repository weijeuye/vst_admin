<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_header">
 <i class="icon-home ihome"></i>
    <ul class="iframe_nav">
        <li><a href="#">首页</a> &gt;</li>
        <li><a href="#">缓存获取</a></li>
    </ul>
</div>

<div class="iframe_search">
    <form method="post" action='/vst_admin/biz/category/findObjFromCacheByKey.do?code=${code}' id="searchForm">
        <table class="s_table">
            <tbody>
            <tr>
                <td class="s_label">key：</td>
                <td><textarea name="key" rows="10" style="width:600px;">${key!''}</textarea></td>
                <td class=" operate mt10"><a class="btn btn_cc1" id="search_button">查询</a></td>
                <td class=" operate mt10">     <span class="form-group">
                        <label class="radio">
                            <input type="radio" name="isSession" value="Y" checked="true"/>
                                    查询session服务器
                        </label>
                        <label class="radio">
                            <input type="radio" name="isSession" value="N"/>
                                    查询非session服务器
                        </label>
                    </span>
                </td>
            </tr>
        </tbody>
    </table>
	</form>
</div>

<!-- 主要内容显示区域\\ -->
<div class="iframe_content">
    <div class="p_box">
	<table class="p_table table_center">
        <tbody>
			${cache!''}
        </tbody>
    </table>

</div><!-- div p_box -->

</div><!-- //主要内容显示区域 -->
<#include "/base/foot.ftl"/>
</body>
</html>

<script>
$(function(){

	$("searchForm input[name='sql']").focus();
		$("#search_button").bind("click",function(){
			$("#searchForm").submit();
	});

});

</script>

