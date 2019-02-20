
<div class="iframe_content mt10">
	<div class="p_box box_info p_line">
		<div id="brand_tab" class="price_tab">
			<input type="hidden" id="productId" value="${productId}"/>
			<input type="hidden" id="categoryId" value="${categoryId}"/>
			<input type="hidden" id="lineRouteId" value="${lineRouteId}"/>
			<input type="hidden" id="subCategoryId" value="${subCategoryId}"/>
			<input type="hidden" id="modelVersion" value="${modelVersion}"/>
			<input type="hidden" id="productType" value="${productType}"/>
			<ul class="J_tab ui_tab">
				<li id="show1" ><a href="javascript:;">行程编辑</a></li>
				<li id="show2" ><a href="javascript:;">行程明细</a></li>
				<li id="show3" ><a href="javascript:;">费用说明</a></li>
				<#if categoryId == 15 ||categoryId == 16>
				<li id="show4"><a href="javascript:;">合同条款</a></li>
				</#if>
			</ul>
		</div>            
	</div>
	<div class="detailInfo" id="detailInfo">
	</div>
</div>
<script>
	var height;
	var width;	
	$(function(){
		var obj = $('#show1');
		showPage(obj);
	 	$("#brand_tab ul li").click(function(e) {
	 		var lineRouteId = $('#lineRouteId').val();
	 		//判断产品规格是已经维护
			if(($(this).attr('id')=='show2' ||$(this).attr('id')=='show3')  && lineRouteId==""){
				$.alert("请先保存行程编辑");
				return;
			}
	        showPage($(this));
	    });
	    
	});
	
	function adaptiveWindow($obj,$obj1){
		var parentWindowObj = $obj1.parents("div.dialog-content");
		var parentWindowWidth = $obj1.parents("div.dialog-content").width();
		var parentWindowHeight= $obj1.parents("div.dialog-content").height();
	   parentWindowObj.css({"overflow-x":"auto","width":parentWindowWidth});
	   parentWindowObj.css({"overflow-y":"auto","height":parentWindowHeight});
	   $obj.css({"width":parentWindowWidth,"height":parentWindowHeight});
	
	}
	
	
	function showPage(obj){
		$("#detailInfo").html("");
	    var productId = $("#productId").val();
	    var categoryId = $("#categoryId").val();
	    var lineRouteId = $("#lineRouteId").val();
	    var subCategoryId = $("#subCategoryId").val();
	    var modelVersion = $("#modelVersion").val();
	    var productType = $("#productType").val();
		var url = ''; 
		if(productId.length<=0){
			obj = $('#show1');
		}
		var id = obj.attr('id');
		if(id=='show1'){
			url = '/vst_admin/prod/prodLineRoute/selectProdLineRoute.do?productId='+productId+"&lineRouteId="+lineRouteId;
		}else if(id=='show2'){
			if(categoryId==15||categoryId==16||(categoryId==18 && subCategoryId != 181&&subCategoryId != 184)){
				url = '/vst_admin/dujia/comm/route/detail/showRouteDetail.do?routeId='+lineRouteId+"&productId="+productId;
				}
			else{
				url = '/vst_admin/prod/prodLineRoute/editprodroutedetail.do?lineRouteId='+lineRouteId+"&productId="+productId;
				}
		}else if(id=='show3'){
			var isNewScenicHotel = (subCategoryId && subCategoryId == 181) && (productType && productType == 'INNERLINE')
			if(isNewScenicHotel) {
				url='/vst_admin/scenicHotel/loadCost.do?lineRouteId='+lineRouteId+"&productId="+productId+"&productType="+productType;
			} else if(modelVersion=="true")
			{
				url='/vst_admin/dujia/group/route/cost/editProdRouteCost.do?lineRouteId='+lineRouteId+"&productId="+productId+"&productType="+productType;
			}	
			else{
				url='/vst_admin/prod/prodLineRoute/editprodroutecost.do?lineRouteId='+lineRouteId+"&productId="+productId;
			}
			
		}
		else if(categoryId==15 || categoryId==16){
			if(modelVersion=="true")
			{
			url='/vst_admin/dujia/group/route/contractDetail/showAddContractDetailList.do?productId='+productId+"&categoryId="+categoryId+"&lineRouteId="+lineRouteId;	
			}
			else{
			url='/vst_admin/prod/product/prodContractDetail/showAddContractDetailList.do?productId='+productId+"&categoryId="+categoryId+"&lineRouteId="+lineRouteId;
			}
		}
		for(var i=1;i<=4; i++){
			$('#show'+i).attr('class','');
		}
		obj.attr('class','active');
		var iframe = "<iframe id='main' class='iframeID' src='"+url+"' style='overflow-x:scroll; overflow-y:scroll;' width='920'  height='566'  frameborder='no' scrolling='auto'/>";
		$(".detailInfo").append(iframe);
		adaptiveWindow($("#main"),obj);
		
	}
	
	
</script>	