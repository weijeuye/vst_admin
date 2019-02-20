<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_search">
<form method="post" action='/vst_admin/biz/citygroup/multiSelectDistrictList.do' id="searchForm">
	<input type="hidden" name="callBack" value="${callBack}"/>
	<input type="hidden" name="elementId" value="${elementId}"/>
	<input type="hidden" name="nameId" value="${nameId}"/>
	<input type="hidden" name="str" id ="str" value="${str!''}">
	<input type="hidden" name="cityGroupId" id ="cityGroupId" value="${cityGroupId!''}">
    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">名称：</td>
                <td class="w18"><input type="text" name="districtName" value="${districtName!''}"></td>
                <td class="s_label">区域类型：</td>
                <td class="w18">
                	<select name="districtType">
                	<option value="">不限</option>
                    	<#list districtTypeList as distType>
                    		<#if districtType == distType.code>
                    		<option value="${distType.code!''}" selected="selected">${distType.cnName!''}</option>
                    		<#else>
                    		<option value="${distType.code!''}">${distType.cnName!''}</option>
                    		</#if>
                    	</#list>
                	</select>
                </td>
                <td class=" operate mt10"><a class="btn btn_cc1" id="search_button">查询</a></td>
                 <input type="hidden" name="page" value="${page}">
            </tr>
        </tbody>
    </table>
	</form>
	<div style=" min-height:20px;margin-top:10px;border-color: inherit;border:1px solid #DBE7EF;background:#F9FAFB;line-height:22px;font-size:12px;color: #666;word-wrap:break-word;word-break:break-all;" id="checked_citys">
    </div>
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
            <th>直接上级目的地</th>
            <th>类型</th>
            <th>拼音</th>
            <th>URL拼音</th>
            </tr>
        </thead>
        <tbody>
			<#list pageParam.items as bizDistrict> 
			<tr>
				<td>
					<input type="checkbox" name="district">
					<input type="hidden" name="districtNameHide" value="${bizDistrict.districtName!''}">
					<input type="hidden" name="districtIdHide" value="${bizDistrict.districtId!''}">
					<input type="hidden" name="foreighFlagHide" value="${bizDistrict.foreighFlag!''}">
				</td>
				<td>${bizDistrict.districtId!''} </td>
				<td>${bizDistrict.districtName!''} </td>
				<td>${(bizDistrict.parentDistrict.districtName)!''} </td>
				<td>${bizDistrict.districtTypeCnName!''} </td>
				<td>${bizDistrict.pinyin!''} </td>
				<td>${bizDistrict.urlPinyin!''} </td>
			</tr>
			</#list>
        </tbody>
    </table>
     <table class="co_table">
        <tbody>
            <tr>
                <td class="operate mt10">
                	<input type="checkbox" name="all_checkbox">全选</input>
                	<a class="btn btn_cc1 add_button">添加</a>
                	<a class="btn btn_cc1" id="next_Button">下一步</a>
                </td>
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
    <div style="border-color: inherit;"></div>
	</div><!--p_box-->
	
</div><!-- //主要内容显示区域 -->
<#include "/base/foot.ftl"/>
</body>
</html>

<script>
$(function(){
   showCitys();
   
  //显示已选中城市信息
  function showCitys() {
	 var strCitys= $("#checked_citys", window.parent.document).val();
	 var str= $("#str").val();
	 if(str == null || str == "" || str == undefined){
	    $("#checked_citys").text('已选择：' + strCitys);
	 }else{
	    $("#checked_citys").text('已选择：' + str +"、" + strCitys);
	 }
	 
  }
  
  //选择单个复选框
$("input[name='district']:checkbox").bind("click",function(){
	//判断是不是所有的checkbox item 都被选中
	var allCheckBoxs = $("input[name='district']:checkbox");
	var checkedBoxs = $("input[name='district']:checkbox:checked");
	if (allCheckBoxs.length == checkedBoxs.length) {
		$("input[name='all_checkbox']").attr("checked", true);
	} else {
		$("input[name='all_checkbox']").attr("checked", false);
	}
});


//全选按钮
$("input[name='all_checkbox']").bind("click",function(){
	if ($(this).is(':checked')) {
		$("input[name = 'district']:checkbox").attr("checked", true);
	} else {
		$("input[name = 'district']:checkbox").attr("checked", false);
	}
});

//添加城市按钮
$(".add_button").bind("click",function(){
	//拿到已选中的checkbox
	var checkedBoxTds = $("input[name='district']:checkbox:checked").parent('td');
	var checkedCitys = new Array();

	$.each(checkedBoxTds, function(index, value) {
		var district = {};
		district.districtId = $("input[name='districtIdHide']",value).val();
		district.districtName = $("input[name='districtNameHide']",value).val();
		district.foreighFlag = $("input[name='foreighFlagHide']",value).val();
		
		var str= $("#str").val(); 
		var splitstr= new Array();
		splitstr=str.split("、");
        $.each(splitstr, function(index, value) {
			if (district.districtName == value) {
			    return;
		    }else{
		        checkedCitys.push(district);
		    }
		});
	});

	if (checkedCitys != '') {
		//保存至父窗口的全局常量中
		window.parent.addTransientCitys(checkedCitys);
	} else {
		return;
	}

	showCitys();
});

//下一步按钮事件添加城市组信息
$("#next_Button").bind("click", function(){
	var cityGroupId = $("#cityGroupId").val(); ;
	var strCityIds= $("#checked_citys_ids", window.parent.document).val();
	var strCitys= $("#checked_citys", window.parent.document).val();
	
	var splitstrCitys = new Array();
	splitstrCitys = strCitys.split("、");
	var falge = true;
	$.each(splitstrCitys, function(index, value) {
		 if(index > 40){
		    alert("添加城市不可以超过40个！");
		    falge = false;
		    return falge;
		 }
	});
	if(falge){
	   if(cityGroupId != null && cityGroupId != "" && cityGroupId != undefined){
	      var updateCitygroupDialog;
	      var url = "/vst_admin/biz/citygroup/getCityGroupById.do";
	      updateCitygroupDialog = new xDialog(url,{"cityGroupId":cityGroupId,"strCityIds":strCityIds,"strCitys":strCitys},{title:"修改城市组信息",width:"1000",height:"900"});
	   }else{
	      var insertCitygroupDialog;
	      var url = "/vst_admin/biz/citygroup/addCityGroup.do";
	      insertCitygroupDialog = new xDialog(url,{"strCityIds":strCityIds,"strCitys":strCitys},{title:"创建城市组信息",width:"1000",height:"900"});
	   }
   } 
	
});


//查询
$("#search_button").bind("click",function(){
	$("#searchForm").submit();
});
  

});




</script>


