<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<#assign voa=JspTaglibs["/WEB-INF/pages//tld/vstOrgAuthentication-tags.tld"]>
<#assign vpa=JspTaglibs["/WEB-INF/pages//tld/productAbandon-tags.tld"]>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>产品列表</title>

 	<link rel="stylesheet" href="/vst_admin/css/ui-common.css" type="text/css" />
	<link rel="stylesheet" href="/vst_admin/css/iframe.css" type="text/css"/>
	<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
	
	
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/product-list.css"/>
	<link rel="stylesheet" href="/vst_admin/css/easyui.css" type="text/css"/>
	<link rel="stylesheet" href="/vst_admin/css/base.css" type="text/css"/>
</head>
<body class="product-list">

<!--页面 开始-->
<div class="everything">

    <!--洋葱皮-->
    <ol class="onionskin">
        <li>
            <a href="#">首页</a>
            <i>&gt;</i>
        </li>
        <li>
            <a href="#">产品关系</a>
            <i>&gt;</i>
        </li>
        <li>
            产品列表
        </li>
    </ol>

    <!--友情提示 开始-->
    <div class="tip tip-warning clearfix mb10">
        <span class="pull-left">
            <span class="icon icon-warning"></span>
            友情提示：
        </span>

        <div class="pull-left">
            1.品类名字后面显示“无效”，表示该品类已经不能做新产品增加。<br/>
            2.可售是指，产品有效、规格有效，且规格下属有有效的商品，且该商品在当前时间往后至少有一天有价格库存
        </div>
    </div>
    <!--友情提示 结束-->

    <!--筛选 开始-->
    <div class="filter">
        <form class="filter-form" method="post" action='/vst_admin/prod/product/findProductRelationList.do' id="searchForm">
            <div class="row">被打包产品：</div>
            <div class="row">
                <div class="col w170">
                    <div class="form-group">
                        <label>
                            <span class="w60 inline-block text-right">产品编号</span>
                            <input class="form-control w90" type="text" id="packagedId" name="packagedId" value="${packagedId!''}" number="true" maxLength="11">
                        </label>
                    </div>
                </div>
                
                <div class="col w170">
                    <div class="form-group">
                        <label>
                            <span class="w60 inline-block text-right">产品关系</span>
                            <select class="form-control w90" id="relationType" name="relationType">
                                <option value="" selected>不限</option>
                                <option value="packaged" <#if prodProduct.relationType=="packaged">selected</#if> >打包关系</option>
                                <option value="relationSale" <#if prodProduct.relationType=="relationSale">selected</#if> >关联销售</option>
                            </select>
                        </label>
                    </div>
                </div>
                <div class="col ">
	                <div class="form-group">
	                	<label <#if packagedProdName??><#else>style="display:none"</#if>>
	                		<span class="w60 inline-block text-right" >产品名称:</span>
	                		<label>${packagedProdName}</label>
	                	</label>
	                </div>
                </div>
                <div class="col w50">
                    <div class="form-group">
                        <a class="JS_btn_more">更多&gt;&gt;</a>
                        <input type="hidden" id="foldingType" name="foldingType" value="${foldingType!''}">
                    </div>
                </div>
            </div>
            <div class="filter-more JS_more">
                <div class="hr ml10 mr10"></div>
                <div class="row">打包产品：</div>
                <div class="row">
                    <div class="col">
	                    <div class="form-group">
	                        <label>
	                            <span class="w50 inline-block text-right">产品品类</span>
	                            <select class="form-control w90" id="categoryId" name="bizCategory.categoryId">
	                                <option value="" selected>不限</option>
				    				<#list bizCategoryList as bizCategory> 
					                    <option value=${bizCategory.categoryId!''} <#if prodProduct.bizCategory!=null && prodProduct.bizCategory.categoryId == bizCategory.categoryId>selected</#if> >${bizCategory.categoryName!''}</option>
					                </#list>
	                            </select>
	                            
	                        </label>
	                        <label>
	                        	<select class="form-control w90" name="subCategoryId" <#if prodProduct.bizCategory==null || prodProduct.bizCategory.categoryId != 18>style = "display:none;"</#if>>
	                   	 			<option value="">不限</option>
				    				<#list subCategoryList as bizCategory> 
				                    	<option value=${bizCategory.categoryId!''} <#if prodProduct.subCategoryId == bizCategory.categoryId>selected</#if> >${bizCategory.categoryName!''}</option>
					                </#list>
					        	</select>
	                        </label>
	                    </div>
	                </div>
                    
                    <div class="col w170">
	                    <div class="form-group">
	                        <label>
	                            <span class="w50 inline-block text-right">产品经理</span>
	
	                            <div class="inline-block">
	                                <input class="search form-control w90" type="text" id="productManagerName" name="productManagerName" value="${productManagerName!''}">
									<input type="hidden" id="productManagerId" name="productManagerId" value="${productManagerId!''}">
	                            </div>
	                        </label>
	                    </div>
	                </div>
                    
                    <div class="col w130">
	                    <div class="form-group">
	                    
	                        <label>
	                            <span>产品状态</span>
	                            <select class="form-control" name="cancelFlag">
	                   					<option value="">全部</option>
				                    	<option value='Y'<#if prodProduct.cancelFlag == 'Y'>selected</#if>>有效</option>
				                    	<option value='N'<#if prodProduct.cancelFlag == 'N'>selected</#if>>无效</option>
	                            </select>
	                        </label>
	                    </div>
                	</div>
	                <div class="col w130">
	                    <div class="form-group">
	                        <label>
	                            <span>是否可售</span>
	                            <select class="form-control" name="saleFlag">
		                	 			<option value="">全部</option>
				                    	<option value='Y' <#if prodProduct.saleFlag == 'Y'>selected</#if> >是</option>
				                    	<option value='N' <#if prodProduct.saleFlag == 'N'>selected</#if> >否</option>
	                            </select>
	                        </label>
	                    </div>
	                </div>
                </div>
            </div>
            <div class="row">
                <div class="col w430"></div>
                <div class="col w400">
                    <span class="btn-group">
                    	<@mis.checkPerm permCode="3523" >
	                    </@mis.checkPerm >
                    	<a class="btn btn-primary JS_btn_select" id="search_button">查询</a>
                    </span>
                </div>
            </div>
        </form>
    </div>
    <!--筛选 结束-->

    <!--产品列表 开始-->
    <#if pageParam??>
    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>

	<div class="product">
	    <table class="table table-border">
	        <colgroup>
	            <col class="w70"/>
	            <col class="w70"/>
	            <col class="product-name"/>
	            <col class="w70"/>
	            <col class="w70"/>
	            <col class="w70"/>
	            <col class="w70"/>
	            <col class="w25p"/>
	            <col class="w70"/>
	        </colgroup>
	        <thead>
	        <tr>
	            <th>品类</th>
	            <th>产品ID</th>
	            <th class="product-name">产品名称</th>
	            <th>打包关系</th>
	            <th>产品经理</th>
	            <th>产品状态</th>
	            <th>是否可售</th>
	            <th>操作日志</th>
	            <th>操作</th>
	        </tr>
	        </thead>
	        <tbody>
	        <tr>
				<#list pageParam.items as product> 
				<tr sensitive="${product.senisitiveFlag}">
	            <td class="text-center"><#if product.bizCategory ??>${product.bizCategory.categoryName!''}</#if><#if product.bizCategory ?? && product.bizCategory.cancelFlag == 'N'><span class="notnull">[无效]</span></#if></td>
	            <td class="text-center">${product.productId!''}</td>
	            <td>${product.productName!''}</td>
	            <td>
	            <#if product.relationType=="relationSale">关联销售</#if>
	            <#if product.relationType=="packaged">打包关系</#if>
	            </td>
	            <td>${product.managerName}</td>
	            <td class="text-center">
	            	<#if product.cancelFlag == "Y">
	                <span class="text-success">有效
	                <#else>
	                <span class="text-danger">无效</span>
	                </#if>
	            </td>
	            <td class="text-center"><#if product.saleFlag =="Y">是<#else>否</#if></td>
	           <td class ="oper-log">
	           		<a href="javascript:void(0);" class="showLogDialog" param='parentId=${product.productId}&parentType=PROD_PRODUCT&sysName=VST' id="showLog" data="${product.productId}" >
	           		${product.operateLog}
	           		</a> 
	           </td>
	            <td class="oper">
	        <!-- 产品权限 -->
			<#assign isPermission =false>
			<@voa.checkPerm managerIdPerm="${product.managerIdPerm!''}">
				<#assign isPermission =true>
			</@voa.checkPerm>	
			
			<#--<#assign isPermission =true>本地使用--> 
			<a style="display: none;" class="categoryId" data-categoryId="<#if product.bizCategory ??>${product.bizCategory.categoryId!''}</#if>"></a>
			<#if isPermission?? && isPermission=false>
				<a href="javascript:void(0);" class="viewProd" data=${product.productId} categoryName="<#if product.bizCategory ??>${product.bizCategory.categoryName!''}</#if>" data1="<#if product.bizCategory ??>${product.bizCategory.categoryId!''}</#if>" data2="${product.modelVersion}" data3="${product.packageType}">查看</a>
			<#else>
	            <#if product.abandonFlag == 'N'>
					<#if product.auditStatus?? && (product.auditStatus=='AUDITTYPE_BACK_PM' ||product.auditStatus=='AUDITTYPE_TO_PM'  ||product.auditStatus=='AUDITTYPE_PASS'  || product.auditStatus=='AUDITTYPE_BACK_QA' || product.auditStatus=='AUDITTYPE_BACK_BUSINESS') && product.hasAuditCategory>
						<a href="javascript:void(0);" class="editProd" data="${product.productId}" categoryName="<#if product.bizCategory ??>${product.bizCategory.categoryName!''}</#if>" data1="<#if product.bizCategory ??>${product.bizCategory.categoryId!''}</#if>" data2="${product.modelVersion}" data3="${product.packageType}" dataProdType="${(product.productType)!''}">编辑</a>
						
	                </#if>
	                <#if !product.hasAuditCategory>
	                    <a href="javascript:void(0);" class="editProd" data="${product.productId}" categoryName="<#if product.bizCategory ??>${product.bizCategory.categoryName!''}</#if>" data1="<#if product.bizCategory ??>${product.bizCategory.categoryId!''}</#if>" data2="${product.modelVersion}" data3="${product.packageType}" dataProdType="${(product.productType)!''}">编辑</a>
	                </#if>
	             </#if>
	         </#if>  
	            </td>
	            </#list>
	        </tr>
	        </tbody>
	    </table>
		<#if pageParam.items?exists> 
			<div class="page-box" > ${pageParam.getPagination()}</div> 
		</#if>
	</div>

	<#else>
	    <div class="hint mb10">
	        <span class="icon icon-big icon-info"></span>抱歉，查询暂无此产品
	    </div>
    </#if>
    </#if>
    <!--产品列表 结束-->
    <div id="showProductTargetBox"  style="display:none;padding:10px; border:1px solid #FF8801; background-color:#FFFFE0;overflow:auto;max-height:200px;">
	</div>
</div>

<!--脚本 模板 开始-->
<div class="template">

<!--选择品类-->

	<!--选择品类-->
	<div class="dialog-category">
	    <iframe src="about:blank" class="iframe-category" frameborder="0" style="width: 680px;"></iframe>
	</div>

</div>
<!--脚本 模板 结束-->

</body>
</html>
<!--页面 结束-->
<script type="text/javascript" src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/product-list.js"></script>
<script type="text/javascript" src="/vst_admin/js/iframe-custom.js"></script>
<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.easyui.min-1.3.1.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>
<script type="text/javascript" src="/vst_admin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.lvtip.js"></script>
<script type="text/javascript" src="/vst_admin/js/newpanel.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.jsonSuggest-2.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_pet_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/log.js"></script>

<script>
var dialogCategory;
$(function() {
	var $template = $(".template");
	
	//显示隐藏 更多条件
    var $btnMore = $(".JS_btn_more");
    var $more = $(".JS_more");
    var type = $("#foldingType").val();
    
    if(type =="open"){
      $more.show();
      $btnMore.data("isDisplay", true).html("收起&lt;&lt;");
    }else{
      $more.hide();
    }
    $btnMore.on("click", btnMoreHandle);
    function btnMoreHandle() {
    	var type = $("#foldingType").val();  	
        var isDisplay = $btnMore.data("isDisplay");
        if (isDisplay) {
        	$("#foldingType").val("close");
            $btnMore.data("isDisplay", false).html("更多&gt;&gt;");
            $more.hide();
        } else {
         	$("#foldingType").val("open");
            $btnMore.data("isDisplay", true).html("收起&lt;&lt;");
            $more.show()
        }
    }
    
  //显示子品类
    $("#categoryId").bind("change", function(){
    	var $categoryId = $(this).val();
    	if($categoryId==18){
    		$("select[name=subCategoryId]").show();
    		$("#brandDiv").hide();
    		$("#brandId").val("");
    		$("#brandName").val("");
    	}else if($categoryId==1){
    		$("#brandDiv").show();
    		$("select[name=subCategoryId]").hide();
    		$("select[name=subCategoryId]").val("");
    	}else{
    		$("#brandDiv").hide();
    		$("#brandId").val("");
    		$("#brandName").val("");
    		$("select[name=subCategoryId]").hide();
    		$("select[name=subCategoryId]").val("");
    	}
    });
    
});
</script>

<script>
var categorySelectDialog;
$(function(){
<@mis.checkPerm permCode="3525" >
//如果是仅查看权限，则移除编辑
//$("a.editProd").remove();
//$("a.cancelProd").remove();
</@mis.checkPerm >

	//查询
	$("#search_button").bind("click",function(){
		if(!$("#searchForm").validate().form()){
				return false;
			}
		$(".iframe-content").empty();
		$(".iframe-content").append("<div class='loading mt20'><img src='../../img/loading.gif' width='32' height='32' alt='加载中'> 加载中...</div>");
		//去掉左右的空格
		$("input[name=productName]").val( $.trim($("input[name=productName]").val()));
        $("input[name=productId]").val( $.trim($("input[name=productId]").val()));
        if($("#packagedId").val()==null||$("#packagedId").val()==""){
        	alert("请输入被打包产品id");
        	return false;
        }
		$("#searchForm").submit();
	});
	
	//修改
	$("a.editProd").bind("click",function(){
		var productId = $(this).attr("data");
		var categoryId = $(this).attr("data1");
		var categoryName = $(this).attr("categoryName");
		var modelVersion = $(this).attr("data2");
		var packageType=$(this).attr("data3");
		var productType=$(this).attr("dataProdType");
		if(modelVersion >= 1.0 && ((categoryId != 18 && categoryId != 16 && categoryId!=15) || (categoryId == 15 && packageType != "LVMAMA"))){
			window.open("/vst_admin/prod/baseProduct/toUpdateSupplierProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName+"&packageType="+packageType);
		}else{
		    if(categoryId == 15 && productType=="FOREIGNLINE" && packageType!="LVMAMA"){
              window.open("/vst_admin/prod/baseProduct/toUpdateSupplierProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName+"&packageType="+packageType);
            }else{
			window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName+"&packageType="+packageType);
			}
		}
		return false;
	});
	
	//查看
	$("a.viewProd").bind("click",function(){
		var productId = $(this).attr("data");
		var categoryId = $(this).attr("data1");
		var categoryName = $(this).attr("categoryName");
		var modelVersion = $(this).attr("data2");
		var packageType=$(this).attr("data3");
		if(modelVersion >= 1.0 && ((categoryId != 18 && categoryId != 16 && categoryId!=15) || (categoryId == 15 && packageType != "LVMAMA"))){
			window.open("/vst_admin/prod/baseProduct/toUpdateSupplierProduct.do?productId="+productId+"&isView=Y&categoryId="+categoryId+"&categoryName="+categoryName+"&packageType="+packageType);
		}else{
			window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&isView=Y&categoryId="+categoryId+"&categoryName="+categoryName+"&packageType="+packageType);
		}
		return false;
	});
	
});
	function confirmAndRefresh(result){
		if (result.code == "success") {
			pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
				$("#searchForm").submit();
			}});
		}else {
			pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
				$.alert(result.message);
			}});
		}
	};
	vst_pet_util.superUserSuggest("#productManagerName","#productManagerId");
  
$(function(){
	showFloat();
});

//预览显示悬浮层
function showFloat(){
	var temp = {};
	var leftpos;
    var toppos;
    var time = {};
    var timer = {};
    
	$('.oper').delegate('a.showProd', 'mouseenter', function(e){
		
		var self = $(this);
		var s = self.attr('data');
		var scends = 1000;
		var url = "/vst_admin/prod/product/findProductGoodsPreview.do?productId="+s;
		if(self.attr("categoryid")==28 ){
			scends=1;
			url = "/vst_admin/prod/product/findWifiProductGoodsPreview.do?productId="+s+"&productType="+self.attr("data_prodtype");
		}
        
        //交通接驳 美食 预览 购物 品类不需要预览商品
        if(self.attr("categoryid")==41 || self.attr("categoryid")==43 || self.attr("categoryid")==44 || self.attr("categoryid")==45){
            return;
        }
		time[s] =setTimeout(function(){
		
		leftpos = e.pageX
		toppos = e.pageY
		clearTimeout(timer[s]);
	if(self.attr('isClicked') == undefined){
			var showflag=false;
			$.ajax({
				  type: "GET",
				  url:url,
				  dataType: "html",
				  async: false,
				  success: function(result){
					  
					  if(result ==""){
						  showflag=true;
						}
						temp[s] = result;
						$("#showProductTargetBox").html(result);
					  }
				});
			self.attr('isClicked',s);
			if(showflag){
				return;
			}
			
			
		}else{
			if(temp[s]!=""){
				$("#showProductTargetBox").html(temp[s]);
			}else{
				return;
			}
		}
		//对于悬浮层超出边界时，位置调整
		if($(document.body).height() - toppos <= $("#showProductTargetBox").height()+33){
			toppos =  toppos -  $("#showProductTargetBox").height()-40;
		
		}
		
		if($(document.body).width() - leftpos <= $("#showProductTargetBox").width()){
			leftpos =  leftpos -  $("#showProductTargetBox").width();
		
		}
		
		timer[s] = setTimeout(function(){
			$('#showProductTargetBox').css("position", "absolute"); 
			$('#showProductTargetBox').css("left",leftpos);
        	$('#showProductTargetBox').css("top", toppos);
			$('#showProductTargetBox').css('display','block');
			$('#showProductTargetBox').attr('data',s);
		},100);
		
		
		
		},scends);
		
	}).delegate('a.showProd', 'mouseleave', function(){
		var self = $(this);
		var s = self.attr('data');
		clearTimeout(time[s]);
		clearTimeout(timer[s]);
		timer[s] = setTimeout(function(){
			$('#showProductTargetBox').css('display','none');
		},100);
	});
	
	$(document.body).delegate('#showProductTargetBox', 'mouseenter', function(){
		clearTimeout(timer[$(this).attr('data')]);
	}).delegate('#showProductTargetBox', 'mouseleave', function(){
		$(this).css('display','none');
	});


}

</script>
