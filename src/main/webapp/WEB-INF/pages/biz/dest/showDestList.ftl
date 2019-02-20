<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_search">
<form method="post" action='/vst_admin/biz/dest/showDestList.do' id="searchForm">
 <input type="hidden" name="type" value="${type}"/>
 
    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">目的地名称：</td>
                <td class="w18"><input type="text" name="destName" value="${destName!''}"></td>
                
                <td class=" operate mt10"><a class="btn btn_cc1" id="search_button">查询</a></td>
                 <input type="hidden" name="page" value="${page}">
            </tr>
        </tbody>
    </table>    
    </form>
</div>
    
<!-- 主要内容显示区域\\ -->
<div class="iframe-content">   
    <div class="p_box">
    <table class="p_table table_center">
        <thead>
            <tr>
            <th>目的地类型</th>
            <th>目的地名称</th>
            <th>目的地介绍内容</th>
            <th>操作</th>
            </tr>
        </thead>
        <tbody>
            <#list pageParam.items as bizDest> 
	            <tr>
		            <td>${bizDest.destTypeCnName!''} </td>
		            <td>${bizDest.destName!''} </td>
		            <td><#if bizDest.bizDestContent??>${bizDest.bizDestContent.intro!''}</#if></td>
		            <td><a href="javascript:void(0);" class="selectAndInsert" destName="${bizDest.destName!''}" destIntro="<#if bizDest.bizDestContent??>${bizDest.bizDestContent.intro!''}</#if>" destPicUrl="<#if bizDest.bizDestContent??>${bizDest.bizDestContent.picUrl!''}</#if>">选择并插入</a></td>
	            </tr>
            </#list>
        </tbody>
    </table>
     <table class="co_table">
        <tbody>
            <tr>
                 <td class="s_label">
                    <#if pageParam.items?exists> 
                        <div class="paging" > 
                        ${pageParam.getPagination()}
                        </div> 
                    </#if>
                 </td>
            </tr>
        </tbody>
    </table>    
    </div><!--p_box-->
    
</div><!-- //主要内容显示区域 -->
<#include "/base/foot.ftl"/>
</body>
</html>

<script>

$(document).ready(function(){
    //查询
    $("#search_button").bind("click",function(){
        if(!$("#searchForm").validate().form()){
            return;
        }
        $("#searchForm").submit();
    });
    
    $("a.selectAndInsert").on('click',function(){
        var destName = $(this).attr("destName");
        var destIntro = $(this).attr("destIntro");
        var destPicUrls = [];
        destPicUrls.push("http://pic.lvmama.com/"+$(this).attr("destPicUrl"));
        parent.lvmamaEditor.insertDetailsCallback(destName,destIntro,destPicUrls);
        parent.comDestContentAddDialog.close();
    });
});






</script>


