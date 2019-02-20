<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<#assign voa=JspTaglibs["/WEB-INF/pages//tld/vstOrgAuthentication-tags.tld"]>
<#assign vpa=JspTaglibs["/WEB-INF/pages//tld/productAbandon-tags.tld"]>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>产品列表</title>
    
	<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/product-list.css"/>
	<link rel="stylesheet" href="/vst_admin/css/jquery.jsonSuggest.css" type="text/css"/>
	<link rel="stylesheet" href="/vst_admin/css/jquery.ui.autocomplete.css" type="text/css"/>
	<link rel="stylesheet" href="/vst_admin/css/jquery.ui.theme.css" type="text/css"/>
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
            <a href="#">华夏航空产品设置 </a>
            <i>&gt;</i>
        </li>
        <li>
            产品列表
        </li>
    </ol>

    <!--筛选 开始-->
    <div class="filter">
        <form class="filter-form" method="post" action='/vst_admin/airlineQuery/findCAirLine.do' id="searchForm">
            <div class="row">
                <div class="col w160">
                    <div class="form-group">
                        <label>
                            <span class="w50 inline-block">产品名称</span>
                            <input class="form-control w90" type="text" name="productName" value="${prodProduct.productName!''}">
                        </label>
                    </div>
                </div>
                <div class="col w170">
                    <div class="form-group">
                        <label>
                            <span class="w50 inline-block text-right">产品ID</span>
                            <input class="form-control w90" type="text" name="productId" value="${prodProduct.productId!''}" number="true" maxLength="11">
                        </label>
                    </div>
                </div>
                <div class="col w160">
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
            <div class="filter-more JS_more">
                <div class="hr ml10 mr10"></div>
                <div class="row">
                    <div class="col w220">
                        <div class="form-group">
                            <label>
                                <span class="w50 inline-block text-right">商品ID</span>
                                <input class="form-control w120" type="text" name="goodsId" value="${goodsId!''}" number="true" />
                            </label>
                        </div>
                    </div>
                    <div class="col w220">
                        <div class="form-group">
                            <label>
                                <span class="w50 inline-block text-right">所属公司</span>
                                <select class="form-control w130 filialeCombobox" name="subCompany">
                                    <option value="">不限</option>
                                <#list filialeNameList as filiale>
                                    <option value="${filiale.code}" <#if subCompany?? && subCompany==filiale.code>selected=selected </#if>  >${filiale.cnName}</option>
                                </#list>
                                </select>
                            </label>
                        </div>
                    </div>
                    <div class="col w270">
                        <div class="form-group">
                            <label>
                                <span class="w100 inline-block text-right">供应商产品名称</span>
                                <input class="form-control w120" type="text"  name="suppProductName" value="${prodProduct.suppProductName!''}" />

                            </label>
                        </div>
                    </div>
                    <div class="col w270">
                        <div class="form-group">
                            <label>
                                <span class="w80 inline-block text-right">审核状态</span>
                                <select class="form-control w130" name="auditStatus">
                                    <option value="">不限</option>
                                <#list auditTypeList as audit>
                                    <option value="${audit.code}" <#if prodProduct?? && prodProduct.auditStatus==audit.code>selected=selected </#if>  >${audit.cnName}</option>
                                </#list>
                                </select>
                            </label>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col w220">
                        <div class="form-group">
                            <label>
                                <span class="w50 inline-block text-right">行政区划</span>
                                <input class="form-control w120" type="text" id=""districtName" name="bizDistrict.districtName" value="<#if prodProduct.bizDistrict??>${prodProduct.bizDistrict.districtName!''}</#if>" />
                            </label>
                        </div>
                    </div>
                    <div class="col w220">
                        <div class="form-group">
                            <label>
                                <span class="w50 inline-block text-right">目的地</span>

                                <div class="inline-block ">
                                    <input class="search form-control w120" type="text" id="destName" name="destName" value="${destName!''}">
                                    <input type="hidden" id="destId" name="destId" value="${destId!''}">
                                </div>
                            </label>
                        </div>
                    </div>
                    <div class="col w270">
                        <div class="form-group">
                            <label>
                                <span class="w100 inline-block text-right">供应商名称</span>
                                <div class="inline-block">
                                    <input class="search form-control w120" type="text" id="supplierName" name="suppSupplier.supplierName" value="<#if prodProduct.suppSupplier??>${prodProduct.suppSupplier.supplierName!''}</#if>">
                                    <input type="hidden"  name="suppSupplier.supplierId" id="supplierId" value="<#if prodProduct.suppSupplier??>${prodProduct.suppSupplier.supplierId!''}</#if>">
                                </div>

                            </label>
                        </div>
                    </div>
                    <div class="col w270" id="brandDiv">
                        <div class="form-group">
                            <label>
                                <span class="w80 inline-block text-right">酒店集团品牌</span>
                                <div class="inline-block">
                                    <input readonly = "readonly" class="w130 search form-control" type="text" id="brandName" name="brandName" value="<#if prodProduct.productBrand??>${brandName!''}</#if>" onclick="showBrandInput();" />
                                    <input type="hidden" name="productBrand.brandId" id="brandId" value="<#if prodProduct.productBrand??>${prodProduct.productBrand.brandId!''}</#if>" >
                                </div>

                            </label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col w430"></div>
                <div class="col w400">
                    <span class="btn-group">
                        <a class="btn" id="search_button">查询</a>
                        <a class="btn btn-primary JS_btn_select"  id="new_button">新增设置</a>
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
                    <col class="w100"/>
                    <col class="w100"/>
                    <col class="product-name"/>
                    <col class="w100"/>
                    <col class="w70"/>
                    <col class="w70"/>
                    <col class="w300"/>
                    <col class="w160"/>
                </colgroup>
                <thead>
                <tr>
                    <th>品类</th>
                    <th>产品ID</th>  
                    <th class="product-name">产品名称</th>
                    <th>产品经理</th>
                    <th>产品状态</th>
                    <th>是否可售</th>
                 	<th>航司限制</th>
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
                        <td>${product.managerName!''} </td>
                        <td class="text-center">
                            <#if product.cancelFlag == "Y">
                            <span class="text-success">有效
                            <#else>
                                <span class="text-danger">无效</span>
                            </#if>
                        </td>
                        <td class="text-center"><#if product.saleFlag =="Y">是<#else>否</#if></td>
                    	
                    	<td>
                    	   <#list product.disIds as ary>
                    	   ${ary}
                            </#list>
                    	</td>
                    	
                       <td>
                            <a href="javascript:void(0);" class="showSetting" data=${product.productId}>设置</a>
                       			&nbsp; &nbsp;
                            <a href="javascript:void(0);" class="repealSetting" data=${product.productId}>取消限制</a>
                            	&nbsp; &nbsp;
                            <a href="javascript:void(0);" class="showLogDialog" param='parentId=${product.productId}&parentType=PROD_AIRLINE&sysName=VST'>日志</a>
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
            <span class="icon icon-big icon-info"></span>抱歉，查询暂无此产品的设置信息，请检查输入或新增设置
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
    <div class="dialog-category">
        <iframe src="about:blank" class="iframe-category" frameborder="0" style="width: 680px;"></iframe>
    </div>
    <!--废弃-->
    <div class="destroy">
        <p class="destroy-title text-danger">
            <span class="icon icon-big icon-danger"></span>
            <span class="destroy-text">警告！“废弃”后将无法在产品列表中呈现</span>
        </p>
        <p class="destroy-content">
            "是" "否" 继续该操作
        </p>

        <div class="btn-group">
            <a class="btn btn-primary JS_btn_yes">是</a>
            <a class="btn JS_btn_no">否</a>
        </div>
    </div>
    <!--公告-->
    <div class="notice">
        <iframe class="notice-iframe" src="about:blank" frameborder="0"></iframe>
    </div>
    <!--一句话推荐-->
    <div class="recommend">
        <iframe class="recommend-iframe" src="about:blank" frameborder="0"></iframe>
    </div>
    <!--礼品-->
    <div class="gift">
        <iframe class="gift-iframe" src="about:blank" frameborder="0"></iframe>
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
            $("input[name=goodsId]").val( $.trim($("input[name=goodsId]").val()));
            $("input[name=suppProductName]").val( $.trim($("input[name=suppProductName]").val()));
            $("#districtName").val( $.trim($("#districtName").val()));

            $("#searchForm").submit();
        });


        //修改
        $("a.editProd").bind("click",function(){
            var productId = $(this).attr("data");
            var categoryId = $(this).attr("data1");
            var categoryName = $(this).attr("categoryName");
            var modelVersion = $(this).attr("data2");
            var packageType=$(this).attr("data3");

            if(modelVersion >= 1.0 && ((categoryId != 18 && categoryId != 16 && categoryId!=15) || (categoryId == 15 && packageType != "LVMAMA"))){
                window.open("/lvmm_dest_back/prod/baseProduct/toUpdateSupplierProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName+"&packageType="+packageType);
            }else{
                window.open("/lvmm_dest_back/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName+"&packageType="+packageType);
            }
            return false;
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

    var selectMethodDialog;
    //设置
    $("a.showSetting").bind("click",function(){
        var productId = $(this).attr("data");
        selectMethodDialog=  new xDialog("/vst_admin/airlineQuery/findSetting.do?productId="+productId+"",{},{title:"设置",width:1040,iframe:true,scrolling:"yes"});
        // new xDialog("/lvmm_dest_back/prod/productNotice/findProductNoticeList.do?productId="+productId+"&noticeType=PRODUCT_All",{},{title:"公告",width:1000,iframe:true,scrolling:"yes"});
    });
    
    //取消限制 
    $("a.repealSetting").bind("click",function(){
    var productId = $(this).attr("data");
	var msg = "确认取消限制吗 ？";	
	$.confirm(msg,function(){
		$.ajax({
			url : "/vst_admin/airlineQuery/repealSetting.do?productId="+productId,
			type : "post",
			dataType:"json",
			async: false,
			data : $("#dataForm").serialize(),
			success : function(result) {
				if(result.code=="success"){
					     $.alert(result.message,function(){
					     $("#searchForm").submit();
				 });
				}else {
					$.alert(result.message);
		   		}
		   },
		
		});		
	});
	
});
    
    //新增设置
    $("#new_button").bind("click",function(){
        var productId = $(this).attr("data");
        new xDialog("/vst_admin/airlineQuery/addSetting.do",{},{title:"新增设置",width:"1200",iframeHeight:"400",iframe:true});
    });

    //礼品
    $("a.showGift").bind("click",function(){
        var productId = $(this).attr("data");
        new xDialog("/lvmm_dest_back/prod/productNotice/findProductNoticeList.do?productId="+productId+"&noticeType=PRODUCT_GIFT",{},{title:"礼品",width:1000,iframe:true,scrolling:"yes"});
    });

    
    vst_pet_util.superUserSuggest("#productManagerName","#productManagerId");
    vst_pet_util.destListSuggest("#destName","#destId", true);
  
</script>
