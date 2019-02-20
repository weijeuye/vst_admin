<#--页面导航-->
<div class="p_box box_info">
	<form method="post"  id="searchForm">
		<input type="hidden" name="prodProductId" value="${prodProductId}"/>
        <table class="s_table">
            <tbody>
                <tr>
                    <td class="s_label">产品ID：</td>
                    <td class="w18" style="width:100px;"><input type="text" style="width:100px;" name="productId" value="${productId!''}" number="true" ></td>
                    <td class="s_label">产品名称：</td>
                    <td class="w18" style="width:100px;"><input type="text" name="productName" value="${productName!''}"></td>
                    <td class="s_label">产品经理：</td>
                    <td class="w18" style="width:100px;"><input type="text" style="width:100px;" name="productManagerName" id="productManagerName" value="${productManagerName!''}"></td>
                    <input type="hidden" id="productManagerId" name="productManagerId" value="${productManagerId!''}">
                    <td class="s_label">行程天数：</td>
                    <td class="w18" style="width:160px;">
	                    <select id="routeDay">
	                    	<!--<option value="" data="">全部</option>-->
	                    	<option value="1" data="0">1天0晚</option>
	                    	<option value="2" data="1">2天1晚</option>
	                    	<option value="3" data="2">3天2晚</option>
	                        <option value="4" data="3">4天3晚</option>
	                    	<option value="5" data="4">5天4晚</option>
	                    	<option value="6" data="5">6天5晚</option>
	                    	<option value="7" data="6">7天6晚</option>
	                    	<option value="8" data="7">8天7晚</option>
	                    	<option value="9" data="8">9天8晚</option>
	                    	<option value="10" data="9">10天9晚</option>
	                    	<option value="11" data="10">11天10晚</option>
	                    	<option value="12" data="11">12天11晚</option>
	                    	<option value="13" data="12">13天12晚</option>
	                    	<option value="14" data="13">14天13晚</option>
	                    	<option value="15" data="14">15天14晚</option>
	                    	<option value="16" data="15">16天15晚</option>
	                    	<option value="17" data="16">17天16晚</option>
	                    	<option value="18" data="17">18天17晚</option>
	                    	<option value="19" data="18">19天18晚</option>
	                    	<option value="20" data="19">20天19晚</option>
	                    </select> 
	                    <input type="hidden" name="routeNum" id="routeNum" value="1"/>
	                    <input type="hidden" name="stayNum" id="stayNum" value="0"/>
                    </td>
                    <td class=" operate mt10">
                   	<a class="btn btn_cc1" id="search_button">查询</a> 
                    </td>
                </tr>
            </tbody>
        </table>	
		</form>
</div>
<form id="dataForm">
<input type="hidden" name="prodProductId" id="prodProductId" value="${prodProductId}"/>
<input type="hidden" name="seq" id="seq" value="1"/>
<input type="hidden" name="dataArray" id="dataArray"/>
<input type="hidden" name="categoryId" id="categoryId" value="${categoryId}"/>
<div class="p_box" id="dataDiv">
	<#include "prod/selfTour/product/selectReProductListForRelate.ftl"/>
</div>
   </form>
  <div class="operate">
  	<a class="btn btn_cc1" id="save_addition">添加关联</a> 
  </div>
  
  <script type="text/javascript" src="/vst_admin/js/vst_pet_util.js"></script>
  <script>
  	//行程天数变化
  	$("#routeDay").on("change",function(){
  		$("#routeNum").val($(this).val());
  		$("#stayNum").val($(getSelectOption("#routeDay")).attr("data"));
  	});
  	
	isView();
	vst_pet_util.superUserSuggest("#productManagerName","#productManagerId");
  	//查询
 	$("#search_button").click(function(){
		$.ajax({
			url : '/vst_admin/selfTour/prodGroup/selectReProductListRelated.do',
			type : 'POST',
			data : $("#searchForm").serialize(),
			success : function(res){
				$("#dataDiv").html(res);
				if(productSelectDialog) {
					productSelectDialog.resizeWH();
				}
			}
		});
	});
 		
 	//设置week选择,全选
	$("input[type=checkbox][name=All]").live("click",function(){
		if($(this).attr("checked")=="checked"){
			$("input[type=checkbox][name=productIds]").attr("checked","checked");
		}else {
			$("input[type=checkbox][name=productIds]").removeAttr("checked");
		}
	})
	
	
	 //设置week选择,单个元素选择
	$("input[type=checkbox][name=productIds]").live("click",function(){
		if($("input[type=checkbox][name=productIds]").size()==$("input[type=checkbox][name=productIds]:checked").size()){
			$("input[type=checkbox][name=All]").attr("checked","checked");
		}else {
			$("input[type=checkbox][name=All]").removeAttr("checked");
		}
	});
 	function getMaxSize(){
		return ${maxSize};
	}
	//添加关联
	function add_prodGroup(obj){
		var array =[];
		array.push(getJson(obj.target));
		setDataArray(array);
		saveProdGroup();
		
	};
	//批量添加关联
	$("#save_addition").click(function(){
		var size =$("input[type=checkbox][name=productIds]:checked").size();
		if(size == 0){
			$.alert("请选择产品");
			return;
		}
		var maxSize= getMaxSize();
		if(size > maxSize){
			$.alert("最多关联产品数目为："+ maxSize);
			return;
		}
		var array =[];
		$("input[type=checkbox][name=productIds]:checked").each(function(){
			array.push(getJson(this));
		});
		setDataArray(array);
		saveProdGroup();
	});
	
	//保存
	function saveProdGroup(obj){
		$.ajax({
			url : '/vst_admin/selfTour/prodGroup/saveProdGroupByRelate.do',
			type : 'POST',
			//async : false,
			data : $("#dataForm").serialize(),
			success : function(rs){
				if(rs.code=='success'){
					$.alert(rs.message, function(){
						productSelectDialog.close();
						window.location.reload();
					});
				}else {
		   		  	$.alert(rs.message);
		   		}
				
			}
		});
		
	}
	
	//获取对象json
	function getJson(obj){
		var json={};
		json.productId = $(obj).attr("data");
		json.categoryId = $(obj).attr("data1");
		json.lineRouteId = $(obj).attr("data2");
		json.routeNum = $(obj).attr("data3");
		json.stayNum = $(obj).attr("data4");
		json.toTraffic = $(obj).attr("data5");
		json.backTraffic = $(obj).attr("data6");
		return json;
	}
	function setDataArray(dataArray){
		$("#dataArray").val(JSON.stringify(dataArray));
	}
	//获取下拉选择项
	function getSelectOption(obj){
  		return $(obj +" option:selected");;
  	}
  </script>