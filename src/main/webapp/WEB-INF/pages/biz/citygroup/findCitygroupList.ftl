<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<#include "/base/head_meta.ftl"/>
		<title>城市组列表</title>
		<style type="text/css">
			input.date{width:80px;}
			.jsonSuggest li a img {
				float:left;
				margin-right:5px;
			}
			.jsonSuggest li a small {
				display:block;
				text-align:right;
			}
			.jsonSuggest { font-size:0.8em; }
			.checks{margin-right:5px;}
			.item_box{width:520px; text-align:left; overflow:hidden; zoom:1;}
			.item_box span{float:left; vertical-align:middle;}
			.repeat_item{display:inline-block; text-align:center;}
			.repeat_item_hasSub{display:inline-block; width:220px; text-align:center; overflow:hidden; zoom:1;}
			.col_repeat  i{float:left; font-style:normal;}
			.width100{ width:70px; overflow:hidden;}
			.width120{ width:120px;overflow:hidden;}
			
			.iframe_content {
             width: 1000px;
             height: 1000px;
             }
		</style>
	</head>
	<body>
			<div class="iframe_search">
			  <form action="/vst_admin/biz/citygroup/findCitygroupList.do" method="post" id="searchForm">
				<table class="s_table">
					<tr>
						<td width="9%" class="s_label">组名称：</td>
						<td width="12%"><input type="text" name="cityGroupName" id="cityGroupName"  value="${RequestParameters.cityGroupName!''}"/></td>
						<td width="6%">产品品类:</td>
						<td width="12%">
						<select name="categoryId" id="categoryId">
						    <#list groupCodeMap?keys as key>
						        <#if key == cityGroup.categoryId>
	                			     <option value="${key!''}" selected="selected">${groupCodeMap[key]!''}</option>
	                		    <#else>
	                		         <option value="${key!''}">${groupCodeMap[key]!''}</option>
	                		    </#if> 
	                	   </#list>
						</select>
						</td>						
						<td width="6%">所属BU:</td>
						<td width="12%">
						<select name="buCode" id="buCode">
						   <#list belongBUMap?keys as key>
	                		<#if key == cityGroup.buCode>
	                			<option value="${key!''}" selected="selected">${belongBUMap[key]!''}</option>
	                		<#else>
	                		    <option value="${key!''}">${belongBUMap[key]!''}</option>
	                		</#if> 
	                	    </#list>
						</select>
						</td>
						<td width="12%">
						 <input type="submit" value="查 询" class="btn btn_cc1"/>
						  <input type="hidden" name="page" value="${page}">
						</td>
					</tr>
				</table>
			</form>
			</div>
			
			
			<div class="iframe_content" >
			<table class="p_table table_center" >
			<tr>
				<th width="5%">选择</th>		
				<th width="10%">编号</th>
				<th width="10%">组名称</th>
				<th width="10%">内容</th>
				<th width="9%">产品品类</th>
				<th width="12%">所属BU</th>	
				<th width="10%">创建人</th>				
				<th width="8%">操作</th>
			</tr>
		   <#if resultPage?? >
			<#if resultPage.items?size gt 0>
			 <#list resultPage.items as citygroup>
			  <tr>
				<td>
				<input type="checkbox" class="checks" id="checkBoxCitygroupId" name="checkBoxCitygroupId" value="${citygroup.cityGroupId!''}"/></td>
				<td>${citygroup.cityGroupId!''}</td>
				<td>${citygroup.cityGroupName!''}</td>
				<td><#if (citygroup.getCityContentMap())??>
				       <#list citygroup.getCityContentMap()?keys as key>
						  ${citygroup.getCityContentMap()[key]!''}
	                   </#list>
				    </#if>
			    </td>
				<td>${citygroup.getZhcategoryName()!''}</td>
				<td>${citygroup.getZhViewBuCode()!''}</td>
				<td>${citygroup.createName!''}</td>
				<td>
					<a class="editcateCityGroup" href="javascript:void(0);" data="${citygroup.cityGroupId!''}">编辑</a>
				    <a class="deletecateCityGroup" href="javascript:void(0);" data="${citygroup.cityGroupId!''}">删除</a>
				</td>
			</tr>
          </#list>
         <#else>
		     <div id="div" class="no_data mt20"><i class="icon-warn32"></i>暂无相关信息，请重新输入相关条件查询！</div>
	     </#if>
	     </#if>
		</table>
		 <table class="co_table">
        <tbody>
            <tr>
                 <td class="s_label">
                 	<#if resultPage.items?exists> 
						<div class="paging" > 
						${resultPage.getPagination()}
						</div> 
					</#if>
                 </td>
            </tr>
        </tbody>
    </table>
		<div class="operate mt20" style="text-align:left;margin-left:50px;">
		    <input type="checkbox" class="checks" id="checkBoxAllCitygroupId" name="checkBoxAllCitygroupId" value="${citygroup.cityGroupId!''}"/></td>
			<a class="btn btn_cc1" href="javascript:deleteCitygroupIdList();" >删除</a>
			<a class="btn btn_cc1" href="javascript:operateCitygroup();">创建城市组</a>
        </div>
        <input type="hidden" id="checked_citys"/>
        <input type="hidden" id="checked_citys_ids"/>
<script type="text/javascript">
//删除
$("a.deletecateCityGroup").bind("click",function(){
   if (confirm("您确定要删除吗！")){
	var cityGroupId=$(this).attr("data");
        $.ajax({
			url : "/vst_admin/biz/citygroup/deleteCateCityGroup.do",
			type : "get",
			data : {cityGroupId : cityGroupId},
			dataType:'JSON',
			success : function(result) {
				 alert("删除成功！");
				 //findCitygroupDialog.reload();
				 location.reload();
			}
	    });
   }else{
      //alert("删除失败！");      
   }
});  
/*全选*/
	$("#checkBoxAllCitygroupId").click(function(){
	    var $arr=$("input[name=checkBoxAllCitygroupId]:checked");
	    if($arr.size()!=0){
	        $("input[name=checkBoxCitygroupId]:checkbox").attr("checked",true);
	    }else{
	        $("input[name=checkBoxCitygroupId]:checkbox").attr("checked",false);
	    }
	});   

 //批量删除	
 function deleteCitygroupIdList(){
     var cityGroupIdList="";
     $("input[type='checkbox']:checkbox").each(function(){ 
        if($(this).attr("checked")){
           cityGroupIdList += $(this).val()+","
        }
     })
     if(cityGroupIdList == ""){
        alert("请选择要删除的选项！");
        return ;
     }

      $.ajax({
			url : "/vst_admin/biz/citygroup/deleteCateCityGroup.do",
			type : "get",
			data : {cityGroupIdList : cityGroupIdList},
			dataType:'JSON',
			success : function(result) {
				 alert("删除成功！");
				// findCitygroupDialog.reload();
				location.reload();
			}
	    });
 }

//修改城市组信息跳转到选择行政区页面
$("a.editcateCityGroup").bind("click",function(){
    var operateCitygroupDialog;
    addTransientCitys('');
    var cityGroupId=$(this).attr("data");
	var url = "/vst_admin/biz/citygroup/multiSelectDistrictList.do?cityGroupId="+cityGroupId;
	operateCitygroupDialog = new xDialog(url,{},{title:"选择出发地",iframe:true,width:"1000",height:"600"});
	
});




	
//创建城市组信息跳转到选择行政区页面
function operateCitygroup(){
    var totalCount = ${totalCount};
    if(totalCount < 100){
       addTransientCitys('');
	   var url = "/vst_admin/biz/citygroup/multiSelectDistrictList.do";
	   operateCitygroupDialog = new xDialog(url,{},{title:"选择出发地",iframe:true,width:"1000",height:"600"});
    }else{
       alert("当前已创建100组城市信息,不能再添加！");
    }
	
}
//----------存储复选城市js开始-----------//
//添加保存弹出页临时的选择的城市组信息
function addTransientCitys(checkedBoxs) {
	if (checkedBoxs == '') {
		window.checkedCitys = new Array();
	} else {
		$.each(checkedBoxs, function(index, value) {
			addCheckedCitys(value);
		});
	}
	//构建已选中城市组字符串
	buildStrCitys();
}

//维护全局变量（去重复）
function addCheckedCitys(city) {
	var isNewCity = true;
	$.each(window.checkedCitys, function(index, value) {
		if (city.districtId == value.districtId) {
			isNewCity = false;
		}
	});
	//如果是一个新的城市信息则添加
	if (isNewCity) {
		window.checkedCitys.push(city);
	}
}

//构建已选中城市组字符串
function buildStrCitys() {
	var strCitys = '';
	var strCityIds = '';
	$.each(window.checkedCitys, function(index, value) {
		strCitys += value.districtName + '、';
		strCityIds += value.districtId + ',';
	});
	if (strCitys != '') {
		strCitys = strCitys.substring(0, strCitys.length-1);
	}
	if (strCityIds != '') {
		strCityIds = strCityIds.substring(0, strCityIds.length-1);
	}
	$("#checked_citys").val(strCitys);
	$("#checked_citys_ids").val(strCityIds);
}
//----------存储复选城市js结束-----------//
	
	 
</script>
	</body>
<#include "/base/foot.ftl"/>
</html>