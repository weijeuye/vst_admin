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
            <a href="#">产品管理</a>
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
        <form class="filter-form" method="post" action='/vst_admin/prod/product/findProductList.do' id="searchForm">
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
                            <input class="form-control w90 digits" type="text" name="productId" value="${prodProduct.productId!''}" number="true" maxLength="11">
                        </label>
                    </div>
                </div>
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
                <div class="col w50">
                    <div class="form-group">
                        <a class="JS_btn_more">更多&gt;&gt;</a>
                        <input type="hidden" id="foldingType" name="foldingType" value="${foldingType!''}">
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
                    <div class="col w270" id="packageModeDiv"<#if prodProduct.bizCategory = null || (prodProduct.bizCategory.categoryId != 15 && prodProduct.bizCategory.categoryId != 16 && 
                    prodProduct.bizCategory.categoryId != 17 && prodProduct.bizCategory.categoryId != 18 && prodProduct.bizCategory.categoryId != 42)>style = "display:none;"</#if>>
                        <div class="form-group">
                            <label>
                                <span class="w70 inline-block text-right">打包类型</span>
	                            <div class="inline-block">
	                                <select class="form-control w120" id="packageType" name="packageType">
		                                <option value="" selected>不限</option>
		                                <option value="LVMAMA" <#if prodProduct.packageType=="LVMAMA">selected</#if> >自主打包</option>
		                                <option value="SUPPLIER" <#if prodProduct.packageType=="SUPPLIER">selected</#if>>供应商打包</option>
		                            </select>
	                            </div>
                                
                            </label>
                        </div>
                    </div>
                    <div class="col w270" id="brandDiv" <#if prodProduct.bizCategory = null || prodProduct.bizCategory.categoryId != 1>style = "display:none;"</#if>>
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
                <div class="row">
                	<div class="col w220" id="productTypeDiv"<#if prodProduct.bizCategory = null || (prodProduct.bizCategory.categoryId != 15 && prodProduct.bizCategory.categoryId != 16 && 
                    prodProduct.bizCategory.categoryId != 17 && prodProduct.bizCategory.categoryId != 18 )>style = "display:none;"</#if>>
                        <div class="form-group">
                            <label>
                                <span class="w50 inline-block text-right">产品类别</span>
	                            <div class="inline-block">
	                            	 <select class="form-control w120" id="productType" name="productType">
	                            	 	<option value="" selected>不限</option>
	                           			 <#if prodProduct.bizCategory?? && prodProduct.bizCategory.categoryId ==15>
			                                <option value="INNERSHORTLINE" <#if prodProduct.productType=="INNERSHORTLINE">selected</#if> >国内-短线</option>
			                                <option value="INNERLONGLINE" <#if prodProduct.productType=="INNERLONGLINE">selected</#if>> 国内-长线</option>
			                                <option value="INNER_BORDER_LINE" <#if prodProduct.productType=="INNER_BORDER_LINE">selected</#if>> 国内-边境游</option>
			                                <option value="FOREIGNLINE" <#if prodProduct.productType=="FOREIGNLINE">selected</#if>> 出境/港澳台</option>
		                        	    <#elseif prodProduct.bizCategory?? && prodProduct.bizCategory.categoryId == 16 >
		                        	    	<option value="INNERSHORTLINE" <#if prodProduct.productType=="INNERSHORTLINE">selected</#if> >国内-短线</option>
			                                <option value="INNERLONGLINE" <#if prodProduct.productType=="INNERLONGLINE">selected</#if>> 国内-长线</option>
			                                <option value="FOREIGNLINE" <#if prodProduct.productType=="FOREIGNLINE">selected</#if>> 出境/港澳台</option>
		                        	    <#else>
			                               	<option value="INNERLINE" <#if prodProduct.productType=="INNERLINE">selected</#if>> 国内</option>
			                                <option value="FOREIGNLINE" <#if prodProduct.productType=="FOREIGNLINE">selected</#if>> 出境/港澳台</option>
		                           		</#if>
		                            </select>
	                            </div>
                                
                            </label>
                        </div>
                    </div>
                    <div class="col w220" id="buDiv"<#if prodProduct.bizCategory = null || (prodProduct.bizCategory.categoryId != 15 && prodProduct.bizCategory.categoryId != 16 && 
                    prodProduct.bizCategory.categoryId != 17 && prodProduct.bizCategory.categoryId != 18 )>style = "display:none;"</#if>>
                        <div class="form-group">
                            <label>
                                <span class="w50 inline-block text-right">BU</span>
	                            <div class="inline-block">
	                                <select class="form-control w120" id="bu" name="bu">
		                                <option value="" selected>不限</option>
		                                <option value="LOCAL_BU" <#if prodProduct.bu=="LOCAL_BU">selected</#if> >大目的地委员会</option>
		                                <option value="DESTINATION_BU" <#if prodProduct.bu=="DESTINATION_BU">selected</#if> >景酒事业部</option>
		                                <option value="OUTBOUND_BU" <#if prodProduct.bu=="OUTBOUND_BU">selected</#if>> 出境游事业部</option>
		                                <option value="TICKET_BU" <#if prodProduct.bu=="TICKET_BU">selected</#if>>景区玩乐事业群</option>
		                                <option value="BUSINESS_BU" <#if prodProduct.bu=="BUSINESS_BU">selected</#if>> 商旅定制事业部</option>
		                                <option value="O2OWUXI_BU" <#if prodProduct.bu=="O2OWUXI_BU">selected</#if>> O2O无锡子公司</option>
		                                <option value="O2ONINGBO_BU" <#if prodProduct.bu=="O2ONINGBO_BU">selected</#if>> O2O宁波子公司</option>
		                            </select>
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
                    	<@mis.checkPerm permCode="3523" >
	                    </@mis.checkPerm >
                        <a class="btn JS_show_dialog_category" id="new_button">新增</a>
                    	<a class="btn btn-primary JS_btn_select" id="search_button">查询</a>
                    </span>
                    <span class="form-group">
                        <label class="radio">
                            <input type="radio" <#if (prodProduct.abandonFlag?if_exists && prodProduct.abandonFlag=="N") || abandonFlag="N">checked</#if> name="abandonFlag" value="N"/>
                            正常产品
                        </label>
                        <label class="radio">
                            <input type="radio" <#if prodProduct.abandonFlag?? &&prodProduct.abandonFlag=="Y">checked</#if> name="abandonFlag" value="Y"/>
                            废弃产品
                        </label>
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
	            <col class="w70"/>
	            <col class="w70"/>
	            <#if showInsProp??>
	               <col class="w70"/>
	            </#if>
	            <col class="w20p"/>
	        </colgroup>
	        <thead>
	        <tr>
	            <th>品类</th>
	            <th>产品ID</th>
	            <th class="product-name">产品名称</th>
	            <th>产品状态</th>
	            <th>是否可售</th>
	            <th>审核状态</th>
	            <th>推荐级别</th>
	            <th>行政区划</th>
	            <th>是否后置</th>
	            <#if showInsProp??>
                   <th>被保天数</th>
                </#if>
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
	            <td class="text-center">
	            	<#if product.cancelFlag == "Y">
	                <span class="text-success">有效
	                <#else>
	                <span class="text-danger">无效</span>
	                </#if>
	            </td>
	            <td class="text-center"><#if product.saleFlag =="Y">是<#else>否</#if></td>
	            <td>
	        		<#if product.auditStatus??>
					<#list auditTypeList as audit>
	            			 <#if product?? && product.auditStatus==audit.code>${audit.cnName}</#if>
	            	</#list>
					<br/>
	            	<#if product.senisitiveFlag=='Y'><span class="text-danger">(敏感词)</span></#if>
	            	</#if>
	            </td>
	            <td class="text-center">
	            	<#if product.bizCategory.categoryId == '188'>
	                <#else>
	                 	${product.recommendLevel}
	                </#if>
	            </td>
	            <td class="text-center"><#if product.bizDistrict??>${product.bizDistrict.districtName!''}</#if></td>
	            <td class="text-center"><#if "Y" == product.travellerDelayFlag>是<#else>否</#if></td>
	            <#if showInsProp??>
	                <#-- 展示保险产品的动态字段：被保天数 -->
    	            <td class="text-center">
    	               <#if product?? && product.prodProductPropList?? && product.prodProductPropList?size &gt; 0>
                           <#list product.prodProductPropList as prop>
                               <#if prop?? && prop_index == 1>
                                   ${prop.propValue!''}
                               </#if>
                           </#list>
                       </#if>
    	            </td>
	            </#if>
	            
	            <td class="oper">
	        <!-- 产品权限 -->
			<#assign isPermission =false>
			<@voa.checkPerm managerIdPerm="${product.managerIdPerm!''}">
				<#assign isPermission =true>
			</@voa.checkPerm>	
			<!-- 特殊品类定义开始 -->
			<#assign isFinance = false>
			<#-- 是否为金融品类 --> 
			<#if product.bizCategory.categoryId == '33'>
				<#assign isFinance = true>
			</#if>
			<#assign isSupermember = false>
			<#-- 是否为超级会员品类 --> 
			<#if product.bizCategory.categoryId == '188'>
				<#assign isSupermember = true>
			</#if>
			<!-- 特殊品类定义结束 -->
			<#--<#assign isPermission =true>本地使用--> 
			<a style="display: none;" class="categoryId" data-categoryId="<#if product.bizCategory ??>${product.bizCategory.categoryId!''}</#if>"></a>
			<#if isPermission?? && isPermission=false && !isFinance && !isSupermember>
				<a href="javascript:void(0);" class="viewProd" data=${product.productId} categoryName="<#if product.bizCategory ??>${product.bizCategory.categoryName!''}</#if>" data1="<#if product.bizCategory ??>${product.bizCategory.categoryId!''}</#if>" data2="${product.modelVersion}" data3="${product.packageType}">查看</a>
			
			<#else>
	            <#if product.abandonFlag == 'N'>
					<#if product.auditStatus?? && (product.auditStatus=='AUDITTYPE_BACK_PM' ||product.auditStatus=='AUDITTYPE_TO_PM'  ||product.auditStatus=='AUDITTYPE_PASS'  || product.auditStatus=='AUDITTYPE_BACK_QA' || product.auditStatus=='AUDITTYPE_BACK_BUSINESS') && product.hasAuditCategory>
						<a href="javascript:void(0);" class="editProd" data="${product.productId}" categoryName="<#if product.bizCategory ??>${product.bizCategory.categoryName!''}</#if>" data1="<#if product.bizCategory ??>${product.bizCategory.categoryId!''}</#if>" data2="${product.modelVersion}" data3="${product.packageType}" dataProdType="${(product.productType)!''}">编辑</a>
						<#if (product.bizCategory.categoryId == '15' || product.bizCategory.categoryId == '16' || product.bizCategory.categoryId == '17' || product.bizCategory.categoryId == '18' || product.bizCategory.categoryId == '42') && product.abandonFlag == 'N'>
	                 		<a href="javascript:void(0);" class="copyProd" productId=${product.productId} categoryId=${product.categoryId} >复制产品</a>
	                	</#if>
	                </#if>
	                <#if !product.hasAuditCategory>
	                    <a href="javascript:void(0);" class="editProd" data="${product.productId}" categoryName="<#if product.bizCategory ??>${product.bizCategory.categoryName!''}</#if>" data1="<#if product.bizCategory ??>${product.bizCategory.categoryId!''}</#if>" data2="${product.modelVersion}" data3="${product.packageType}" dataProdType="${(product.productType)!''}">编辑</a>
	                </#if>
	             </#if>
	                
                <#if product.abandonFlag == 'N' && !isFinance && !isSupermember>
	                <#if product.auditStatus?? && (product.auditStatus=='AUDITTYPE_TO_QA'||product.auditStatus=='AUDITTYPE_TO_BUSINESS') && product.hasAuditCategory && product.abandonFlag == 'N'>
						<@mis.checkPerm permCode="3928" >
	               	 		<a href="javascript:void(0);" class="viewProd" data=${product.productId} categoryName="<#if product.bizCategory ??>${product.bizCategory.categoryName!''}</#if>" data1="<#if product.bizCategory ??>${product.bizCategory.categoryId!''}</#if>" data2="${product.modelVersion}" data3="${product.packageType}">查看</a>
						</@mis.checkPerm >
					<#else>
						<@mis.checkPerm permCode="3928" >
	                    	<a href="javascript:void(0);" class="viewProd" data=${product.productId} categoryName="<#if product.bizCategory ??>${product.bizCategory.categoryName!''}</#if>" data1="<#if product.bizCategory ??>${product.bizCategory.categoryId!''}</#if>" data2="${product.modelVersion}" data3="${product.packageType}">查看</a>
						</@mis.checkPerm >
					</#if>
			 	</#if>
				<#if !(product.bizCategory.categoryId == 13) && !isFinance && !isSupermember && !((product.bizCategory.categoryId == '17'||(product.bizCategory.categoryId == '18' && product.subCategoryId =='181')) && product.productType!='FOREIGNLINE' && (product.abandonFlag?if_exists && product.abandonFlag=="Y"))>
					<a href="javascript:void(0);" class="showProd" data1="${product.urlId}"   data=${product.productId} categoryId=${product.bizCategory.categoryId} 
						district="<#if product.bizDistrict ??>${product.bizDistrict.pinyin!''}</#if>"<#if product.bizCategory.categoryId==28>data_prodtype="${product.productType}"</#if>>预览</a>
			   </#if>
			   <#if isFinance>
					<a href ="javascript:return false;"  style="pointer-events:none;" data1="${product.urlId}"   data=${product.productId} categoryId=${product.bizCategory.categoryId} >预览</a>
			   </#if>
              	<#if product.abandonFlag == 'N'>
              	    <#if isFinance || isSupermember>
              	    <#else>
		                <@mis.checkPerm permCode="3526" >
		                    <a href="javascript:void(0);" class="showNotice" data=${product.productId}>公告</a>
		                </@mis.checkPerm >
		                <@mis.checkPerm permCode="3527" >
		                    <a href="javascript:void(0);" class="showRecommend" data=${product.productId}>一句话推荐</a>
		                </@mis.checkPerm >
		                <@mis.checkPerm permCode="3528" >
		                    <a href="javascript:void(0);" class="showGift" data=${product.productId}>礼品</a>
		                </@mis.checkPerm >
 					</#if>	                
	                <a href="javascript:void(0);" class="showLogDialog" param='parentId=${product.productId}&parentType=PROD_PRODUCT&sysName=VST'>操作日志</a> 
	                
	                <#if product.auditStatus?? && product.auditStatus=='AUDITTYPE_PASS' && product.hasAuditCategory >
	                    <#if product.cancelFlag == "Y"> 
	                    <a href="javascript:void(0);" class="cancelProd" data="N" productId=${product.productId}>设为无效</a>
	                    <#else>
	                    <a href="javascript:void(0);" class="cancelProd" data="Y" productId=${product.productId}>设为有效</a>
	                     </#if>
	               	</#if>
	               	
	               	<#if !product.hasAuditCategory >
	               	<@mis.checkPerm permCode="3529" >
	                    <#if product.cancelFlag == "Y"> 
	                    <a href="javascript:void(0);" class="cancelProd" data="N" productId=${product.productId}>设为无效</a>
	                    <#else>
	                    <a href="javascript:void(0);" class="cancelProd" data="Y" productId=${product.productId}>设为有效</a>
	                     </#if>
	                </@mis.checkPerm >
	               	</#if>
	                <#if product.hasAuditCategory && !isSupermember>
	                	<a href="javascript:void(0);" class="showLogDialog" param='objectId=${product.productId}&objectType=PROD_PRODUCT_PRODUCT&logType=PROD_PRODUCT_ADUIT_STATUS&sysName=VST'>审核备注</a>
	                </#if>
	                 <#if product.auditStatus?? && product.auditStatus=='AUDITTYPE_TO_PM'>
	                 <#if product.source != 'BACK' && product.source!=null>
	                 <a href="javascript:void(0);" class="audit" currentAuditType="AUDITTYPE_TO_PM" source= ${product.source}   data=${product.productId} data1=${product.bizCategory.categoryId} data2=${product.bizCategory.categoryName!''}>产品经理审核</a>
	                 </#if>
	                 <#if product.source == 'BACK' >
	                    <a href="javascript:void(0);" class="commitAudit" currentAuditType="${product.auditStatus}" data="${product.productId}" categoryId="${product.bizCategory.categoryId}" source= "${product.source}">提交审核</a>
	                </#if>
	                </#if>
	                <#--只针对线路品类-->
					<#if product.auditStatus?? && (product.auditStatus=='AUDITTYPE_BACK_QA' || product.auditStatus=='AUDITTYPE_BACK_PM'|| product.auditStatus=='AUDITTYPE_BACK_BUSINESS') && product.hasAuditCategory>
						<a href="javascript:void(0);" class="commitAudit" currentAuditType="${product.auditStatus}" data=${product.productId} categoryId=${product.bizCategory.categoryId} source= ${product.source}>提交审核</a>
					<#elseif product.auditStatus?? && (product.auditStatus=='AUDITTYPE_TO_QA'||product.auditStatus=='AUDITTYPE_TO_BUSINESS') && product.hasAuditCategory> 
						<a href="javascript:void(0);" class="cancelAudit" currentAuditType="${product.auditStatus}" data=${product.productId} categoryId=${product.bizCategory.categoryId} >撤销审核</a>
					</#if>
				</#if>	
					<#if product.cancelFlag?? && product.cancelFlag == "N" && product.abandonFlag == 'N' && !isSupermember>
	                    <a href="javascript:void(0);" class="abandonFlag" data="Y" productId=${product.productId}>废弃</a>
					<#elseif product.abandonFlag == 'Y'>
                        <#if product.cancelFlag == 'Y'>
							<#if product.suppGoods?? && product.suppGoods.bu??>
								<#assign suppGoodsBu =product.suppGoods.bu>
							</else>
								<#assign suppGoodsBu =''>
							</#if>
                            <@vpa.checkPerm managerIdPerm="${product.managerIdPerm!''}" suppGoodsBu="${suppGoodsBu}" categoryId="${product.bizCategoryId!''}" bu="${product.bu!''}">
                                <a href="javascript:void(0);" class="abandonFlag" data="N" productId=${product.productId}>还原</a>
                            </@vpa.checkPerm>
                        <#else>
                            <a href="javascript:void(0);" class="abandonFlag" data="N" productId=${product.productId}>还原</a>
                        </#if>
	                </#if>
	                <#if (product.bizCategory.categoryId == '17'|| (product.bizCategory.categoryId == '18' && product.subCategoryId =='181' ))&& product.productType!='FOREIGNLINE' && (product.abandonFlag?if_exists && product.abandonFlag=="N")>
	                	<a href="javascript:void(0);" class='appPreview' data ="${product.productId}" cancelFlag="${product.cancelFlag}" saleFlag="${product.saleFlag}">app预览
	                </#if>
	           </#if>
	            <#-- 金融品类 -->
           		<#if isFinance>
					<a href="javascript:void(0);" class="copyFinanceProd" productId=${product.productId} categoryId=${product.categoryId} >复制产品</a>
				</#if>
	           	<#--演出票日期选择方式-->
	           	<#if product.bizCategory.categoryId == showTicket.categoryId>
				   <a href="javascript:void(0);" class="dateChoiceType" data="${product.productId}">日期选择方式</a>
				</#if>
	           	<#-- 邮轮组合产品复制 -->
				<#if product.bizCategory.categoryId == '8' && product.packageType == 'SUPPLIER'>
					<a href="javascript:void(0);" class="copyCompShipProd" productId=${product.productId} categoryId=${product.categoryId} >复制产品</a>
				</#if>
				<#if product.isSupportTravellerDelay>
					<@mis.checkPerm permCode="5254" >
					<a href="javascript:void(0);" class="setTravellerDelay"  productId=${product.productId}>游玩人设置</a>
					</@mis.checkPerm>  
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
    	if($categoryId==18 || $categoryId==15 || $categoryId==16 || $categoryId==17 || $categoryId==42){
    		$("#packageModeDiv").show();
    	}else{
    		$("#packageModeDiv").hide();
    		$("#packageType").val("");
    	}
    	if($categoryId==18 || $categoryId==15 || $categoryId==16 || $categoryId==17){
    		$("#productTypeDiv").show();
    		$("#buDiv").show();
    		$("#productType").empty(); 
    		if( $categoryId==15){
		    	$("#productType").append("<option value=''>不限</option><option value='INNERSHORTLINE'>国内-短线</option><option value='INNERLONGLINE'> 国内-长线</option><option value='INNER_BORDER_LINE'> 国内-边境游</option><option value='FOREIGNLINE'> 出境/港澳台</option>");
		    }else if($categoryId==16){
		    	$("#productType").append("<option value=''>不限</option><option value='INNERSHORTLINE'>国内-短线</option><option value='INNERLONGLINE'> 国内-长线</option><option value='FOREIGNLINE'> 出境/港澳台</option>");
	    	}else if($categoryId==18 ||$categoryId==17){
	    		$("#productType").append("<option value=''>不限</option><option value='INNERLINE'> 国内</option><option value='FOREIGNLINE'> 出境/港澳台</option>");
	    	}
    	}else{
    		$("#productTypeDiv").hide();
    		$("#productType").val("");
    		$("#buDiv").hide();
    		$("#bu").val("");
    	}
    	
    });
	
	//新增产品品类
	$(".JS_show_dialog_category").on("click", showDialogCategoryHandle);
	function showDialogCategoryHandle() {
	    var $category = $template.find(".dialog-category").clone();
	    dialogCategory = backstage.dialog({
	        width: 680,
	        height: 310,
	        title: "选择品类",
	        $content: $category
	    });
	    var url = "/vst_admin/prod/product/showSelectCategory.do";
	    var $iframe = $category.find(".iframe-category");
	    $iframe.attr("src", url);
	}
	
	//废弃产品
	$(".abandonFlag").on("click", function() {
		var entity = $(this);
		var abandonFlag = entity.attr("data");
		var productId = entity.attr("productId");
		var $destroy = $template.find(".destroy").clone();
		var dialogDestroy = backstage.dialog({
			width: 380,
			height: 190,
			title: "",
			$content: $destroy
		});
		if(abandonFlag=="Y") {
			$destroy.find(".destroy-text").html("警告！“废弃”后将无法在产品列表中呈现");
		} else {
			$destroy.find(".destroy-text").html("“还原”后将在正常产品列表中呈现");
		}
        var categoryId = entity.siblings(".categoryId").attr("data-categoryId");
        var url="/vst_admin/prod/product/abandonProduct.do";
        if(categoryId=="2"||categoryId=="8"||categoryId=="9"||categoryId=="10"){
            url = "/ship_back/prod/product/abandonProduct.do";
        }
		$destroy.find(".JS_btn_yes").on("click", function () {
			$.ajax({
				url : url,
				type : "post",
				dataType:"JSON",
				data : {"abandonFlag":abandonFlag,"productId":productId},
				success : function(result) {
				if (result.code == "success") {
				   $("#searchForm").submit();
				}else {
					$.alert(result.message);
				}
				}
			});
		});
		$destroy.find(".JS_btn_no").on("click", function () {
			console.log("no");
			dialogDestroy.destroy();
		});


	});
});

	//dongningbo 酒店集团品牌 start
	function showSelectBrandDialog(){
		//打开下拉列表并且为动态业务字典窗口
		var url = "/vst_admin/biz/bizBrand/findSelectBrandList.do";
	
		brandSelectDialog = new xDialog(url, {}, {
			title : "酒店集团品牌",
			iframe : true,
			width : "600",
			height : "600"
		});
	}

	function showBrandInput() {
		//打开下拉列表并且为动态业务字典窗口
		showSelectBrandDialog();
	}
	function onSelectBrand(params){
		$("#brandId").val(params.brandId);
		$("#brandName").val(params.brandName);
		brandSelectDialog.close();
	}
	//end 
</script>

<script>
vst_pet_util.commListSuggest("#supplierName", "#supplierId",'/vst_back/supp/supplier/searchSupplierList.do','${suppJsonList}');
var categorySelectDialog;

$(function(){
<@mis.checkPerm permCode="3525" >
//如果是仅查看权限，则移除编辑
//$("a.editProd").remove();
//$("a.cancelProd").remove();
</@mis.checkPerm >

//产品规格
	$("a.prodBranch").bind("click",function(){
		var productId = $(this).attr("data");
		var categoryId = $(this).attr("data_catId");
		window.location.href="/vst_admin/prod/prodbranch/findProductBranchList.do?productId="+productId+"&categoryId="+categoryId;
	});
	
	//提交审核
	$("a.commitAudit").bind("click",function(){
		var productId = $(this).attr("data");
		var categoryId = $(this).attr("categoryId");
		var currentAuditType=$(this).attr("currentAuditType");
		var source = $(this).attr("source");
		var msg = '确认提交审核?';
		var saveRouteFlag;
        var url="/vst_admin/prod/product/updateAudtiType.do";
        if(categoryId=="2"||categoryId=="8"||categoryId=="9"||categoryId=="10"){
            url = "/ship_back/prod/product/updateAudtiType.do";
        }else{
            $.ajax({
                url : "/vst_admin/prod/product/findsaveRouteFlag.do",
                type : "post",
                dataType:"JSON",
                data : {"productId":productId},
                async:false,
                success : function(result) {
                    if (result.code == "success") {

                    }else if(result.code== "saveRouteFlag"){
                        saveRouteFlag = result.message;
                    }
                    else {
                        msg = result.message+'确定提交审核?';
                    }
                }
            });
        }
		if(saveRouteFlag == "N"){
			$.alert("请先创建行程明细");
		}else{
		$.confirm(msg,function(){
			$.ajax({
				url : url,
				type : "post",
				dataType:"JSON",
				data : {"productId":productId,"currentAuditStatus":currentAuditType,"isPass" : "Y",isSubmit:'Y',"source":source,"bizCategoryId":categoryId,"source":source},
				success : function(result) {
				if (result.code == "success") {
					$.alert(result.message,function(){
						$("#search_button").click();
					});
				}else {
					$.alert(result.message);
				}
				}
			});
		});
		}
	});
	

	
	//撤销审核
	$("a.cancelAudit").bind("click",function(){
		var productId = $(this).attr("data");
		var categoryId = $(this).attr("categoryId");
		var currentAuditType=$(this).attr("currentAuditType");
	var htmlArray = [];
	htmlArray.push('<div id="aduitDiv">');
	htmlArray.push('<div style="margin:5px;">确定撤回审核</div>');	
	htmlArray.push('<div class="operate" style="margin-left:5px;margin-top:20px;"><a class="btn btn_cc1" id="cancel_audit_submit" currentAuditType='+currentAuditType+' data='+productId+' data-categoryId="'+categoryId+'">提交</a><a class="btn btn_cc1" id="cancel_audit_cancel">取消</a></div>');
	htmlArray.push('</div>');
	
	auditDialog = pandora.dialog({
        width: 500,
        title: "撤销审核",
        mask : true,
        content: htmlArray.join('')
	 });
	});
	
	$("#cancel_audit_submit").live("click",function(){
			var data = $(this).attr("data");
			var currentAuditType  = $(this).attr("currentAuditType");
			var source = $(".audit").attr("source");
			var categoryId = $(this).attr("data-categoryId");
			var url="/vst_admin/prod/product/cancelAudtiType.do";
			if(categoryId=="2"||categoryId=="8"||categoryId=="9"||categoryId=="10"){
				url = "/ship_back/prod/product/cancelAudtiType.do";
			}
			$.ajax({
				url : url,
				type : "post",
				dataType:"JSON",
				data : {"productId":data,"source":source,"currentAuditStatus":currentAuditType},
				success : function(result) {
				if (result.code == "success") {
					$.alert(result.message,function(){
						$("#search_button").click();
					});
				}else {
					$.alert(result.message);
				}
				}
			});
	});
	
//商品维护
	$("a.prodGoods").bind("click",function(){
		var productId = $(this).attr("dataProductId");
		var cancelFlag = $(this).attr("dataCancelFlag");
		if(cancelFlag=="Y"){
			window.location.href="/vst_admin/goods/goods/showSuppGoodsList.do?productId="+productId;
		}else{
			$.alert("该产品不可用！");
		}
	});

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
	
	//新建
	//$("#new_button").bind("click",function(){
	//	//打开弹出窗口
	//	categorySelectDialog = new xDialog("/vst_admin/prod/product/showSelectCategory.do",{},{title:"请选择产品的所属品类",width:900,height:600});
	//	return;
	//});
	
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
	
	//日期选择类型
	var dateChoiceTypeDialog;
	$("a.dateChoiceType").bind("click",function(){
	    var productId = $(this).attr("data");
	    dateChoiceTypeDialog = new xDialog("/vst_admin/showTicket/prod/product/showDateChoiceType.do?productId="+productId,{},{title:"日期选择方式",width:"600px",height:"600px"});
	});
	//景酒 app预览二维码
	var appPictureDialog;
	$("a.appPreview").bind("click",function(){
		var productId = $(this).attr("data");
		var cancelFlag = $(this).attr("cancelFlag");
		var saleFlag = $(this).attr("saleFlag");
		appPictureDialog =new xDialog("/vst_admin/packageTour/prod/product/showAppPreviewCode.do?productId="+productId+"&cancelFlag="+cancelFlag+"&saleFlag="+saleFlag,{},{title:"app预览二维码",width:"500px",height:"500px"});
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
	
	
	//预览
	$("a.showProd").bind("click",function(){
		var productId = $(this).attr("data");
		var categoryId = $(this).attr("categoryId");
		var urlId = $(this).attr("data1");
		if(categoryId=="1"){
            preview(categoryId,productId);
		}else if(categoryId=="11" ){
			preview(categoryId,urlId);
		}else if( categoryId=="12"){
            preview(categoryId,productId);
		}else if(categoryId=="13"){
			$.alert("该产品不能预览");
			return;
		}else if(categoryId=="8"){
            preview(categoryId,productId);
		}else if(categoryId=="15"){
            preview(categoryId,urlId);
		}else if(categoryId=="16"){
            preview(categoryId,urlId);
		}else if(categoryId=="17"){
            preview(categoryId,urlId);
		}else if(categoryId=="18"){
            preview(categoryId,urlId);
		}else if(categoryId=="4"){
            preview(categoryId,$(this).attr("district"));
        }else if(categoryId=="41"){
          	preview(categoryId,urlId);
        }else if(categoryId == "31"){
            preview(categoryId,productId);
		}else if(categoryId=="32"){	//新品类酒套餐
            preview(categoryId,productId);
        }else if(categoryId == "42"){
        	preview(categoryId,urlId);
        }else if(categoryId=="43"){
           preview(categoryId,urlId);
        }else if(categoryId=="44"){
           preview(categoryId,urlId);
        }else if(categoryId=="45"){
           preview(categoryId,urlId);
        }else {
			$.alert("该产品不能预览");
			return;
		}
	});


	
	$("#cancel_audit_cancel").live("click",function(){
		auditDialog.close();
	});

	//设置为预览
	function preview(categoryId,previewId){
        window.open("/vst_admin/prod/baseProduct/preview.do?categoryId="+categoryId+"&previewId="+previewId);
	}
	
//设置为有效或无效
	$("a.cancelProd").bind("click",function(){
		var entity = $(this);
		var cancelFlag = entity.attr("data");
		var productId = entity.attr("productId");
		var categoryId = entity.siblings(".categoryId").attr("data-categoryId");
		var url="/vst_admin/prod/product/cancelProduct.do";
		if(categoryId=="2"||categoryId=="8"||categoryId=="9"||categoryId=="10"){
			url = "/ship_back/prod/product/cancelProduct.do";
		}
		if(categoryId == "4"){
            url = "/visa_prod/visa/product/cancelProduct.do";
        }
		 msg = cancelFlag === "N" ? "确认设为无效  ？" : "确认设为有效  ？";
	 $.confirm(msg, function () {
		$.ajax({
			url : url,
			type : "post",
			dataType:"JSON",
			data : {"cancelFlag":cancelFlag,"productId":productId,"bizCategoryId":categoryId},
			success : function(result) {
			if (result.code == "success") {
				$.alert(result.message,function(){
					$("#searchForm").submit();
				});
			}else {
				$.alert(result.message);
			}
			}
		});
		});
	});
	
	//复制线路产品
	$("a.copyProd").bind("click",function(){
		var entity = $(this);
		var productId = entity.attr("productId");
		var categoryId = entity.attr("categoryId");
	 $.confirm("确认复制产品 ？", function () {
		$.ajax({
			url : "/vst_admin/packageTour/prod/product/copyProduct.do?productId="+productId+"&categoryId="+categoryId,
			type : "post",
			dataType:"JSON",
			success : function(result) {
			if (result.code == "success") {
				$.alert(result.message,function(){
					$("#searchForm").submit();
				});
			}else {
				$.alert(result.message);
			}
			}
		});
		});
	});
	
	//复制邮轮组合产品
	$("a.copyCompShipProd").bind("click", function(){
		var entity = $(this);
		var productId = entity.attr("productId");
		var categoryId = entity.attr("categoryId");
	 	$.confirm("确认复制产品 ？", function () {
			$.ajax({
				url : "/ship_back/compship/prod/product/copyCompProduct.do?productId="+productId+"&categoryId="+categoryId,
				type : "post",
				dataType:"JSON",
				success : function(result) {
					if(result.code == "success") {
						$.alert(result.message,function(){
							$("#searchForm").submit();
						});
					} else {
						$.alert(result.message);
					}
				}
			});
		});
	});
	
	//复制金融产品
	$("a.copyFinanceProd").bind("click",function(){
		var entity = $(this);
		var productId = entity.attr("productId");
		var categoryId = entity.attr("categoryId");
	 $.confirm("确认复制产品 ？", function () {
        //遮罩层
        var loading = pandora.loading("正在努力复制中...");
		$.ajax({
			url : "/vst_admin/finance/prod/product/copyProduct.do?productId="+productId+"&categoryId="+categoryId,
			type : "post",
			dataType:"JSON",
			success : function(result) {
	            loading.close();
				if (result.code == "success") {
					confirmAndRefresh(result);
				}else {
					$.alert(result.message);
				}
				
			}
		});
		});
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
	
		//公告
	$("a.showNotice").bind("click",function(){
		var productId = $(this).attr("data");
	new xDialog("/vst_admin/prod/productNotice/findProductNoticeList.do?productId="+productId+"&noticeType=PRODUCT_All",{},{title:"公告",width:1000,iframe:true,scrolling:"yes"});
	});
	
			//一句话推荐
	$("a.showRecommend").bind("click",function(){
		var productId = $(this).attr("data");
	new xDialog("/vst_admin/prod/productNotice/findProductNoticeList.do?productId="+productId+"&noticeType=PRODUCT_RECOMMEND",{},{title:"一句话推荐",width:1000,iframe:true,scrolling:"yes"});
	});
	
			//礼品
	$("a.showGift").bind("click",function(){
		var productId = $(this).attr("data");
	new xDialog("/vst_admin/prod/productNotice/findProductNoticeList.do?productId="+productId+"&noticeType=PRODUCT_GIFT",{},{title:"礼品",width:1000,iframe:true,scrolling:"yes"});
	});
	
	vst_pet_util.superUserSuggest("#productManagerName","#productManagerId");
	vst_pet_util.destListSuggest("#destName","#destId", true);
	
	$(".audit").click(function(){
		currentAuditType = $(this).attr("currentAuditType");
		productId = $(this).attr("data");
		var categoryId = $(this).attr("data1");
		var categoryName = $(this).attr("data2");
		var markhtml = '<div id="auditNotPass" categoryName="'+categoryName+'" data1="'+categoryId+'" data ="'+productId+'"></div>'
		var htmlArray = [];
		htmlArray.push('<div id="aduitDiv">');
		htmlArray.push('<div style="margin:5px;"><input type="radio" name="isPass" value="Y">审核通过</div>');
		htmlArray.push('<div style="margin:5px;"><input type="radio" name="isPass" checked="checked" value="N"/>审核不通过'+markhtml+'</div>');
		htmlArray.push('<div style="margin:5px;"><textarea name="content" style="width:400px;height:50px;resize:none;"></textarea></div>');
		htmlArray.push('<div class="operate" style="margin-left:5px;margin-top:20px;"><a class="btn btn_cc1" id="audit_submit">提交</a><a class="btn btn_cc1" id="audit_cancel">取消</a></div>');
		htmlArray.push('</div>');
		auditDialog = pandora.dialog({
	        width: 500,
	        title: "提交审核结果",
	        mask : true,
	        content: htmlArray.join('')
		 });
	});
	
	$("#audit_submit").live("click",function(){
		var msg;
		var source = $(".audit").attr("source");
		var productId = $("#auditNotPass").attr("data");
		var categoryId = $("#auditNotPass").attr("data1");
		var categoryName = $("#auditNotPass").attr("categoryName");
		var settingUrl = "/vst_admin/tour/goods/goods/showBaseSuppGoods.do?prodProductId="+productId+"&categoryId="+categoryId
		$.ajax({
					url : "/vst_admin/prod/product/getSensitiveFlag.do",
					type : "post",
					dataType:"JSON",
					data : {"productId":productId},
					async:false,
					success : function(result) {
						if (result.code == "success") {
							msg = "确定提交？";
						}else {
							msg = result.message+'确定提交?';
						}
					}
			});
			
		$.confirm(msg,function(){
			var isPass = $("input[name='isPass']:checked").val();
			var content = $.trim($("textarea[name='content']").val());
			if(isPass=="N"&&content==""){
				$.alert("必须填写审核不通过原因");
				return;
			}
			
			$.ajax({
				url : "/vst_admin/prod/product/updateAudtiType.do",
				type : "post",
				dataType:"JSON",
				data : {"productId":productId,"currentAuditStatus":currentAuditType,"isPass" : isPass,"content" : content,"source":source,"bizCategoryId":categoryId},
				success : function(result) {
					if (result.code == "success") {
						$.alert(result.message,function(){
							 auditDialog.close();
							$("#search_button").click();
						});
					}else if(result.settingFlag == true){
						var notice;
						var settingFlag = result.settingFlag;
						notice = '<font color="red">提示:未设置归属BU或归属地</font>,<a target="_blank"  href="'+settingUrl+'" >' +'<font color="blue">去设置!</font></a>'
						$("#auditNotPass").html(notice);
					}else if(result.result_settleEntity == "failed"){
						// 判断产品下商品是否有未绑定结算对象
                        var settle_notice;
                        settle_notice = '<font color="red">提示:'+result.msg_settleEntity+'</font>'
                        $("#auditNotPass").html(settle_notice);
					}else if(result.settingOperFlag == true){
						var notice;
						var settingFlag = result.settingFlag;
						notice = '<font color="red">提示: “运营类别”为空，请告知相关产品经理修改后提交</font>'
						$("#auditNotPass").html(notice);
				    }else{
							$.alert(result.message);
					}
				}
			});
		});
	});
	
	
	$("#audit_cancel").live("click",function(){
			auditDialog.close();
	});
	
	/*游玩人设置*/
	$(".setTravellerDelay").bind("click",function(){
		var productId = $(this).attr("productId");
		travellerDelayDialog = new xDialog("/vst_admin/prod/product/showProdTravellerConfig.do",{"productId": productId},{title:"游玩人设置",width:400,height:200});
	})		
    
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

$("select.filialeCombobox").combobox({
    multiple:false,
    filter:function(q,row){
		var opts=$(this).combobox("options");
		return row[opts.textField].indexOf(q) > -1;
	}
});
</script>
