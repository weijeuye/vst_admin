<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_search">
    <form method="post" action='/vst_admin/superfreetour/hotPlaceManage/selectTrafficPointList.do' id="searchForm">
        <table class="s_table">
            <tbody>
            <tr>
                <td class="s_label">交通点ID：</td>
                <td class="w18"><input type="text" name="signId" value="${signId!''}" number=true></td>
                <td class="s_label">交通点名称：</td>
                <td class="w18"><input type="text" name="signName" value="${signName!''}"></td>
                <td class="s_label">交通点类型：</td>
                <td class="w18">
                    <select name="signType">
                            <option value="">不限</option>
                    	<#list signTypeList as signTypeItem>
                            <#if signType == signTypeItem.id>
                    		<option value="${signTypeItem.id!''}" selected="selected">${signTypeItem.cnName!''}</option>
                            <#elseif signTypeItem.id != "2002">
                    		<option value="${signTypeItem.id!''}">${signTypeItem.cnName!''}</option>
                            </#if>
                        </#list>
                    </select>
                </td>
                <td colspan="2" class=" operate mt10"><a class="btn btn_cc1" id="search_button">查询</a><input type="hidden" name="page" value="${page}">
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
                <th>选择</th>
                <th>编号</th>
                <th>名称</th>
                <th>行政区名称</th>
                <th>拼音</th>
                <th>简拼</th>
                <th>描述</th>
                <th>状态</th>
            </tr>
            </thead>
            <tbody>
			<#list pageParam.items as bizDist>
            <tr>
                <td>
                    <input type="radio" name="bizDist" value="${bizDist.signId!''}">
                    <input type="hidden" name="signNameHide" value="${bizDist.signName!''}">
                    <input type="hidden" name="signIdHide" value="${bizDist.signId!''}">
                    <input type="hidden" name="signTypeCnNameHide" value="${bizDist.signTypeCnName!''}">
                    <input type="hidden" name="signTypeHide" value="${bizDist.signType!''}">
                    <input type="hidden" name="cancelFlag" value="${bizDist.cancelFlag!''}">
                    <input type="hidden" name="districtId" value="${bizDist.districtId!''}" >
                    <input type="hidden" name="longitudeHidden" value="${bizDist.longitude!''}" >
                    <input type="hidden" name="latitudeHidden" value="${bizDist.latitude!''}" >
                </td>
                <td>${bizDist.signId!''} </td>
                <td>${bizDist.signName!''} </td>
                <td>${bizDist.districtName!''}</td>
                <td>${bizDist.pinyin!''} </td>
                <td>${bizDist.shortPinyin!''} </td>
                <td>${bizDist.signDesc!''} </td>
                <td><#if bizDist.cancelFlag == 'Y'>有效<#else>无效</#if> </td>
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

    //查询
    $("#search_button").bind("click",function(){
        if(!$("#searchForm").validate().form()){
            return;
        }
        $("#searchForm").submit();
    });

    $("input[type='radio']").bind("click",function(){
        var obj = $(this).parent("td");
        var bizDist = {};
        bizDist.signId = $("input[name='signIdHide']",obj).val();
        bizDist.signName = $("input[name='signNameHide']",obj).val();
        bizDist.signType = $("input[name='signTypeHide']",obj).val();
        bizDist.signTypeCnName = $("input[name='signTypeCnNameHide']",obj).val();
        bizDist.cancelFlag = $("input[name='cancelFlag']",obj).val();
        bizDist.districtId = $("input[name='districtId']",obj).val();
        bizDist.longitude = $("input[name='longitudeHidden']",obj).val();
        bizDist.latitude = $("input[name='latitudeHidden']",obj).val();
        parent.onSelectbizDist(bizDist);
    });
</script>


