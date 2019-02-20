<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
<#include "/base/foot.ftl"/>
<link rel="stylesheet"  href="/vst_admin/css/hotelCommbPackageSelect.css" type="text/css"/>
<style type="text/css">
.pages a{
background:#f80;
cursor:pointer;
}
.pages a:hover{
background:#f81;
}
</style>
</head>
<body style="min-height:950px;">
<div class="iframe_content">
    <div class="p_box box_info">
    <form method="post" action='#' id="searchForm">
     <input type="hidden" id="groupProductId" name="groupProductId" value="${groupProductId!''}"/>
     <input type="hidden" id="productId" name="productId" value="${productId!''}"/>
     <input type="hidden" id="groupType" name="groupType" value="${groupType!''}"/>
     <input type="hidden" id="categoryId" name="categoryId" value="${categoryId!''}"/>
     <input type="hidden" id="detailId" name="detailId" value="${detailId!''}"/>
     <input type="hidden" id="branchName" name="branchName" value="${branchName!''}"/>
     <input type="hidden" id="productBranchId" name="productBranchId" value="${productBranchId!''}"/>
        <table class="s_table">
            <tbody>
                <tr>
                    <td align="right">规格名称：</td>
                    <td class="w18"><input type="text" name="branchName" value="${branchName!''}" disabled="true"></td>
                    <td align="right">规格ID：</td>
                    <td class="w18"><input type="text" name="productBranchId" disabled="true" value="${productBranchId!''}"></td>
					<td align="right">行政区划：</td>
                    <td class="w18">
						<input type="text"  name="districtName" id="districtName" />
					</td>
					<td align="right">是否可售：</td>
					<td class="w18">
						 <select id="onlineFlag" name="onlineFlag">
	                    	<option value="" selected="">全部</option>
			                    <option value='Y'>是</option>
			                    <option value='N'>否</option>
	                    </select>
					  </td>
                </tr>
                <tr>
                <td align="right">商品名称：</td>
                <td class="w18"><input id="goodsName" type="text" name="goodsName" /></td>
                <td align="right">商品ID：</td>
                <td class="w18"><input id="suppGoodsId" type="text" name="suppGoodsId" number="true" /></td>
                <td align="right">供应商名称：</td>
                <td class="w18">
	                <input type="text" class="searchInput" name="supplierName" value="${supplierName!''}" id="supplierName" />
					<input type="hidden" name="supplierId"  value="${supplierId!''}" id="supplierId"/>
				</td>
                <td><a class="btn btn_cc1" id="search_button">查询</a><a onclick="searchReset()" class="btn btn_cc1">重置</a></td>
                <td><a class="btn btn_cc1" id="packageGoodsToBranch">确认打包</a></td>
                </tr>
            </tbody>
        </table>	
		</form>
	<div class="check_wrap">
        <div class="title">已选商品:</div>
    <div class="check_container" style="min-width: 800px;">
        <ul id='goodsCartUl'></ul>
    </div>
    </div>
		<li id="label_mini_templete"  data-id="" data-name="" title="" style="display:none;"><span></span><a  href="javascript:;">×</a></li>
	</div>
	<div id='contentData'></div>
</div>
</body>
</html>
<script type="text/javascript">
vst_pet_util.commListSuggest("#supplierName", "#supplierId",'/vst_back/supp/supplier/searchSupplierList.do','');
//设置商品勾选和商品添加到商品栏中
function setCheckedAndAddGoods(goodsIdStr,goodsNameStr)
{
	//需要勾选的商品id数组 
	var willCheckedGoodsId = ConvertStringToArray(goodsIdStr);
	var willCheckedGoodsName = ConvertStringToArray(goodsNameStr);
   //商品栏中已经添加的数据 
	var certGoodsIdArray = getGoodsCartGoodsId();
	var goodsIdUL = $(".check_container ul");
	var branchName = $("#branchName").val();
    if(certGoodsIdArray.length==0 || certGoodsIdArray==null || certGoodsIdArray == undefined)
   	{
   	  //如果商品栏中为空 则将系统逻辑商品或者已经打包的商品 全部添加到商品栏中
   	   addGoodsToGoodCart(willCheckedGoodsId,willCheckedGoodsName);
   	}else
	{
   	  for(var i=0;i<willCheckedGoodsId.length;i++)
	  {
	   		var goodsId = willCheckedGoodsId[i];
	   		var goodsName = willCheckedGoodsName[i];
	   		//返回true 则 商品栏中已经存在 ,返回false 则商品栏中不存在 
	   		var result = ValidateGoodsidInGoodCart(goodsId);
	   		if( goodsId != "" && goodsId != undefined)
   			{
	   			if(result)
				{
		   		  $("#checkbox"+willCheckedGoodsId[i]).attr("checked","true");
				 continue;
				}else{
					$("#checkbox"+willCheckedGoodsId[i]).attr("checked","true");
					   var $clone = $("#label_mini_templete").clone();
						$clone.find("span").text(goodsName+"【"+branchName+"】"+goodsId);
						$clone.attr({"data-id":goodsId,"data-name":goodsName,"title":goodsName});
						goodsIdUL.append($clone);
						$clone.show();
				}
   			}else{
   				continue;
   			}
	  }
	}	
};

//将商品数组 勾选并添加到商品栏
function addGoodsToGoodCart(willCheckedGoodsId,willCheckedGoodsName)
{
	var goodsIdUL = $(".check_container ul");
	var branchName = $("#branchName").val();
	 for(var i=0;i<willCheckedGoodsId.length;i++)
	  {
  		var goodsId = willCheckedGoodsId[i];
  		var goodsName = willCheckedGoodsName[i];
  		//返回true 则 商品栏中已经存在 ,返回false 则商品栏中不存在 
  		var result = ValidateGoodsidInGoodCart(goodsId);
  		if(goodsId != "" && goodsId !=undefined)
  		{
  			if(result)
  			{
  	  		  $("#checkbox"+willCheckedGoodsId[i]).attr("checked","true");
  			 continue;
  			}else{
  				$("#checkbox"+willCheckedGoodsId[i]).attr("checked","true");
  				   var $clone = $("#label_mini_templete").clone();
  					$clone.find("span").text(goodsName+"【"+branchName+"】"+goodsId);
  					$clone.attr({"data-id":goodsId,"data-name":goodsName,"title":goodsName});
  					goodsIdUL.append($clone);
  					$clone.show();
  			}
  		}else{
  			continue; 
  		}
	  }
};

//获取 商品栏中的所有商品id
function getGoodsCartGoodsId()
{
	//获取商品列表中的 所有的商品li 
	var allLiItem = $(".check_container").children("ul").children("li");
	// 购物栏 商品id数组 
	var certGoodsIdArray = new Array();
	allLiItem.each(function(index, dom){
		// 获取商品id
		var goodsIdData = $(dom).attr("data-id");
		certGoodsIdArray.push(goodsIdData);
	});
	return certGoodsIdArray;
}

//判断勾选的商品 在商品栏中是否存在 ,返回ture表示存在,返回false表示不存在
function ValidateGoodsidInGoodCart(goodsId)
{
	//获取商品栏中的所有商品id
	var certGoodsIdArray = getGoodsCartGoodsId();
	if(certGoodsIdArray.length==0)
	{
	 return false;
	}
	else
	{
		for(var i=0;i<=certGoodsIdArray.length;i++)
		{
		  if(i>=certGoodsIdArray.length)
		  {//对比所有元素都不相同 返回 false
		  return false;
		  }else
		  {
			  if(goodsId != certGoodsIdArray[i])
			  {
			   continue;
			  }else if(goodsId==certGoodsIdArray[i])
			  {
			    return true;
			    break;
			  }else {
				  return false;
			  }
		 }
		};
	}
	
}
$(function(){
	var searchFlag=false;
	// ajax提交表单
	$("#search_button").click(function(){
	    searchFlag=true;
	    if (!$("#searchForm").validate().form()) {
            return false;
        }
	    queryFirstOpenData(searchFlag);
	 
    }); 
	 //选中商品标签删除时联动取消复选框选中状态	
    $(".check_container li").live("click", function (e) {
      e = e || event;
      var target = e.target || e.srcElement;
      if (target.tagName.toLowerCase() === "a") {
          var goodsId = $(this).attr("data-id");
          $(this).remove();
			$("input[name='checkOjectId']:checked").each(function(){
				var objectId = $(this).val();
				if(goodsId == objectId){
				$(this).prop("checked",false);
			}
		
		});
      }
  });  	
	$(document).delegate("input[name='checkOjectId']","click",function(e){
		var $this = $(this);
		var branchName = $("#branchName").val();
		var objectName = $this.parents("tr").find(".objectName").attr("title");
		var goodsId = $this.val();
		if($this.is(":checked"))
		{
		  /* 如果被勾选  */
		  /* 返回ture 则表示在购物车中存在,返回false则表示不存在 */
		   var result = ValidateGoodsidInGoodCart(goodsId);
		  if(result==true)
		  {
		    return true;
		  }else if(result==false)
		  {
			  addSingleCheckedGoodsToGoodsCert(objectName,branchName,goodsId);
		  }
		}else
		{
			/* 如果取消勾选  */
		  /* 将取消勾选的商品在商品栏移除 */
		  $(".check_container").find("li[data-id=" + goodsId + "]").remove();
			/* 只有有一个取消勾选 就将全选勾选取消  */
		  $("#selectAllItems").attr("checked", false);
		}
     });
	
	//对商品进行打包 
    $("#packageGoodsToBranch").bind("click", function() {
    	var strArray = getGoodsCartGoodsId();
    	var allIdArry = new Array();
    	var allItem = $("input[name='checkOjectId']");
		allItem.each(function(index, dom){
			var objectId = $(dom).val();
			allIdArry.push(objectId);
		});
		var jsonAllId = convertArrayToJsonString(allIdArry);
    	var jsonText = convertArrayToJsonString(strArray);
    	var productBranchId = $("#productBranchId").val();
    	var groupProductId = $("#groupProductId").val();
    	var detailId = $("#detailId").val();
    	var groupType = $("#groupType").val();
		if(strArray.length <= 0){
			$.alert("请至少选择一个商品!");
			return;
		}
    	 else
   		 {
    		 $.confirm("确认打包吗 ？",function() {
    		 var loading = top.pandora.loading("正在努力保存中...");
    		 $.ajax({
 				type : "POST",
 				url : "/vst_admin/productPack/hotel/addGoodsToBranch.do?productBranchId="+productBranchId+"&detailId="+detailId+"&groupProductId="+groupProductId+"&groupType="+groupType,
 				dataType : "json",
 				data : {key:jsonText,jsonAllId:jsonAllId},
 				success : function(result) {
 				    loading.close();
					if(result.code == "success"){
						if(parent.window.lv_reload) {
							parent.window.lv_reload();
						} else {
							parent.window.location.reload(); 
						}
					}
					if(result.code == "error"){
						$.alert(result.message);
					}
				},
				error : function(result) {
					loading.close();
					$.alert(result.message);
				}
 			});            
    	  });
   		}
	});
  //全选/全不选
    $(document).delegate("#selectAllItems","click",function(e){ 
    	var allItem = $("input[name='checkOjectId']");
    	if($(this).attr("checked")) {
    		allItem.each(function(index, dom){
    			$(dom).attr("checked", true);
    			var $clone = $("#label_mini_templete").clone();
    			var objectId = $(dom).val();
    			var branchName = $("#branchName").val();
    			//判断勾选的商品是否在商品栏中存在
    			var result = ValidateGoodsidInGoodCart(objectId);
    			if(!result)
   				{
    				var objectName = $(dom).parents("tr").find(".objectName").attr("title");
        			var objectsuppGoodsId = $(dom).parents("tr").find(".objectsuppGoodsId").attr("title");
        			$clone.find("span").text(objectName+"【"+branchName+"】"+objectsuppGoodsId);
        			$clone.attr({"data-id":objectId,"data-name":objectName,"title":objectName});
        			$(".check_container ul").append($clone);
   				}
    			$clone.show();
    		});
    	} else {
    		//如果全选按钮由 全选变为全不选 则将不选的商品循环移除
    		allItem.each(function(index, dom){
    			$(dom).attr("checked", false);
    			var goodsId = $(dom).val();
    			$(".check_container").find("li[data-id=" + goodsId + "]").remove();
    		});
    	}
    });
	queryFirstOpenData(searchFlag);
});

function convertArrayToJsonString(strArray){ 
	var jsonText = JSON.stringify(strArray);
	return jsonText;
}

//分页或者查询数据时 对已经在商品栏中添加的数据进行勾选
function setCartGoodsIdChecked()
{
	var allItem = $("input[name='checkOjectId']");
	allItem.each(function(index, dom){
			var objectId = $(dom).val();
			//判断勾选的商品是否在商品栏中存在
			var result = ValidateGoodsidInGoodCart(objectId);
			if(result)
			{
				$(dom).attr("checked", true);
			}
		});
};
function addSingleCheckedGoodsToGoodsCert(objectName,branchName,goodsId)
{
	var $clone = $("#label_mini_templete").clone();
    $clone.find("span").text(objectName+"【"+branchName+"】"+goodsId);
	$clone.attr({"data-id":goodsId,"data-name":objectName,"title":objectName});
	$(".check_container ul").append($clone);
	$clone.show();
} 
//系统逻辑下将勾选所有商品 
function setAllChecked()
{
	var whetherPackaged = $("#whetherPackaged").val();
	if(whetherPackaged=="false") {
		$("#selectAllItems").attr("checked", true);
		var allItem = $("input[name='checkOjectId']");
		allItem.each(function(index, dom){
			$(dom).attr("checked", true);
		});
	}
	else
	{
	return true;
	}
}
function ConvertStringToArray(str)
{
	var strsArray= new Array(); //定义一数组
	strsArray=str.split(","); //字符分割 
	return strsArray;
}
//第一次打开该页面时查询默认的商品数据
function queryFirstOpenData(searchFlag)
 {
	 $.ajax({
			type : "POST",
			async: true,
			url : "/vst_admin/productPack/hotel/showGoodsData.do",
			dataType : "html",
			data : $("#searchForm").serialize(),
			success : function(result) {
				ajaxResultSolve(result);
			}
		});
}

function asyncQuery(url)
{ 
	 $.ajax({
			type : "POST",
			async: true,
			url : url,
			dataType : "html",
			success : function(result) {
				ajaxResultSolve(result);
			}
		});
}

//对异步查询结果进行处理
function ajaxResultSolve(result)
{
	document.getElementById("contentData").innerHTML = result;
	 //系统逻辑下 商品id拼接字符串 
	 var systemLogicGoodsIdString = $("#systemLogicGoodsIdString").val();
	 //系统逻辑下 商品名称拼接字符串 
	 var systemLogicGoodsNameString = $("#systemLogicGoodsNameString").val();
	 //已打包的商品id拼接字符串 
	 var suppGoodsIdString = $("#suppGoodsIdString").val();
	 //已打包的商品名称拼接字符串 
	 var goodsNameString = $("#goodsNameString").val();
	 var whetherPackaged = $("#whetherPackaged").val();
	 if(whetherPackaged=="false")
	 {
		 /* 如过返回的数据是没有打包的数据则全部勾选数据 ,并添加到商品栏 */
		 setAllChecked();
		 setCheckedAndAddGoods(systemLogicGoodsIdString,systemLogicGoodsNameString);
	 }
	 else if(whetherPackaged=="true")
	 {
	   //如果是打包过的数据 则将打包的数据勾选,并将打包的商品添加到商品栏 
		 setCheckedAndAddGoods(suppGoodsIdString,goodsNameString);
	 }
	 setCartGoodsIdChecked();
	 cleanCancelStr();
}

function openProduct(productId, categoryId, supplierName,suppGoodsId,supplierId,hotelOnLineFlag){
	var groupType = $("#groupType").val();
	var supplierNameValue="";
	var url="";
    if(supplierName!="")
	{
		supplierNameValue = encodeURI(supplierName);
	}
    if(groupType=="HOTEL")
    {
    if(hotelOnLineFlag == 'true'){
	 	url="/lvmm_dest_back/goods/goods/showSuppGoodsList.do?productId="+productId+"&categoryId="+categoryId+"&automaticQuery='true'"+"&supplierName='"+supplierNameValue +"'&supplierId="+supplierId;
    }else{
	 	url="/vst_admin/goods/goods/showSuppGoodsList.do?productId="+productId+"&categoryId="+categoryId+"&automaticQuery=true"+"&supplierName="+supplierNameValue+"&supplierId="+supplierId;
    }
	 window.open(url);
    }else if(groupType=="LINE_TICKET")
   	{
     url = '/scenic_back/ticket/goods/goods/showSuppGoodsList.do?productId='+productId+"&automaticQuery=true"+"&supplierName="+supplierNameValue+"&supplierId="+supplierId+"&categoryId="+categoryId;
     window.open(url);
   	}
   
}

function showGoodsTimePrice(productId, branchId, supplierId,suppGoodsId,hotelOnLineFlag){
	var groupType = $("#groupType").val();
	var url="";
	 if(groupType=="HOTEL")
    {
    	if(hotelOnLineFlag=="true"){
    		//酒店系统上线，跳转到新时间价格表页面
			 url="/lvmm_dest_back/goods/timePrice/showGoodsTimePrice.do?prodProduct.productId="+productId+"&prodProductBranch.bizBranch.branchId="+branchId+"&suppSupplier.supplierId="+supplierId+"&suppGoodsId="+suppGoodsId+"&backToLastPageButtonHidden=true";
    	}else{
    		//跳转到老时间价格表页面
			url="/vst_admin/goods/timePrice/showGoodsTimePrice.do?prodProduct.productId="+productId+"&prodProductBranch.bizBranch.branchId="+branchId+"&suppSupplier.supplierId="+supplierId+"&suppGoodsId="+suppGoodsId+"&backToLastPageButtonHidden=true";
    	}
    }else if(groupType=="LINE_TICKET")
   	{
         url='/scenic_back/ticket/goods/timePrice/showGoodsTimePrice.do?suppGoodsId='+suppGoodsId+'&prodProduct.productId='+productId+"&backToLastPageButtonHidden=true";
   	}
    window.open(url);
}
function searchReset()
{
	$("#districtName").val("");
	$("#onlineFlag").val("");
	$("#goodsName").val("");
	$("#suppGoodsId").val("");
	$("#supplierName").val("");
}

//对无效商品进行特殊处理 
function cleanCancelStr()
{
	// 获取商品列表中的 所有的商品li 
	var allLiItem = $(".check_container").children("ul").children("li");
	if(allLiItem.length>0)
	{
		 allLiItem.each(function(index,dom){
			 var spanDom = $(dom).children("span");
				var spanText = spanDom.text();
				if(spanText.indexOf("【(cancelGoods)】") != -1)
				{
					spanText=spanText.replace("【(cancelGoods)】","");
					$(spanDom).text("");
					$(spanDom).append("<s style='color:red'>"+spanText+"</s>"+"【无效商品】");
				}
			});
	}
};

</script>
