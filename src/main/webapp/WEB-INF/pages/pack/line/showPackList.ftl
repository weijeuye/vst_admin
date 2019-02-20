<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>

<link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/lv/icons.css,/styles/lv/tips.css" type="text/css" />

<script type="text/javascript" src="http://super.lvmama.com/vst_admin/js/prod/packageTour/product/pack_update_clause_line.js"></script>

</head>
<body>
<div class="iframe_header">
    <ul class="iframe_nav">
        <li><a href="#">${categoryName !''}</a> &gt;</li>
        <li><a href="#">自主打包</a> &gt;</li>
        <li><a href="#">组合打包</a> </li>
    </ul>
</div> 
<div class="iframe_content mt10">
    <div class="tiptext tip-warning"><span class="tip-icon tip-icon-warning"></span>
    <#if groupType == 'HOTEL'>
        注：选择有预付商品的产品，前台仅调取预付商品<br/>
        注：前台购买，每个区间段，必须且仅可购买一个规格的商品……若是用户可选是否要，请在“运营>关联销售”里面维护。<br/>
        注：新增酒店的时间段，需要注意其是否已经添加了与之入住晚有交集的线路产品
    <#elseif groupType == 'LINE'>
        注：选择有预付商品的产品，前台仅调取预付商品。<br/>
        注：前台购买，每个区间段，必须且仅可购买一个规格的商品……若是用户可选是否要，请在“运营>关联销售”里面维护。<br/>
        注：新增线路的时间段，需要注意其是否已经添加了与之入住晚有交集的酒店产品<br/>
        注：选择线路产品，同一个时间段里面的线路产品，行程天数、入住晚数，需要完全一致<br/>
        注：自由行、跟团游，一个时间段里面只能有一个产品。主要为了用户前台的交互体验
    <#elseif  groupType == 'LINE_TICKET'>
        注：选择有预付商品的产品，前台仅调取预付商品。<br/>
        注：前台购买，每个区间段，必须且仅可购买一个规格的商品……若是用户可选是否要，请在“运营>关联销售”里面维护。<br/>
    <#elseif  groupType == 'TRANSPORT'>
        注：选择有预付商品的产品，前台仅调取预付商品。<br/>
        注：前台购买，每个区间段，必须且仅可购买一个规格的商品……若是用户可选是否要，请在“运营>关联销售”里面维护。<br/>
    </#if>
    </div><br/>
<#assign routeNum = '' />
<#assign stayNum = '' />
<#if prodProduct.prodLineRouteList ?? >
    <#assign routeNum=prodProduct.prodLineRouteList[0].routeNum />
    <#assign stayNum=prodProduct.prodLineRouteList[0].stayNum />
</#if>
<#if prodProduct ?? >
    <input type="hidden" id = "freedomRouteGoodsHotelPackageId" name="freedomRouteGoodsHotelPackageId" value='${prodProduct.bizCategoryId!''}'/>
</#if>
<#assign cancelFlag={"Y":"有效","N":"无效"}>
<#assign saleFlag={"Y":"可售","N":"不可售"}>
    <input type="hidden" id = "isShowGoods" name="isShowGoods" value="${isShowGoods!''}"/>
    <input type="hidden" id = "groupType" name="groupType" value="${groupType }"/>
    <input type="hidden" id = "productId" name="productId" value="${productId }"/>
    <input type="hidden" id = "productType" name="productType" value="${productType }"/>
    <input type="hidden" id = "BU" name="BU" value="${BU}"/>
    <input type="hidden" id = "categoryId" name="categoryId" value="${categoryId}"/>
    <input type="hidden" id = "groupId" name="groupId" />
    <input type="hidden" id = "routeNum" name="routeNum" value="${routeNum }" />
    <input type="hidden" id = "stayNum" name="stayNum" value="${stayNum }" />
    <input type="hidden" id = "subCategoryId" name="subCategoryId" value="${prodProduct.subCategoryId!'' }"/>
    <input type="hidden" id = "categoryParentId" name="categoryParentId" value="${categoryParentId }"/>
    <input type="hidden" id = "selectParentCategoryFlag" name="selectParentCategoryFlag" value="${selectParentCategoryFlag }"/>
    <input type="hidden" id = "cancelFlag" name="cancelFlag" value="${prodProduct.cancelFlag!'' }"/>
    
    <input type="hidden" id="needToast" value="${needToast!'N'}"/>

<form action="" method="post" id="dataForm">
	 <#if selectCategoryList??>
	 	<#list selectCategoryList as bizCategory> 
	 		<#if bizCategory.categoryCode!='category_traffic' && bizCategory.categoryCode!='category_route_customized'><#--排除定制游 -->
	 		<div class="p_box box_info p_line" <#if bizCategory.categoryId =='15' && lineGroupHidFlag == 'true'>style="display:none"<#else>style="border:solid 1px #aaa"</#if> >
	            <div class="box_content">
	                <table class="e_table form-inline" style="width: 1054px" >
	                    <tbody>
		                <tr style="background-color:#E4E4E4">
		                	<td class="e_label" width="20px" style="font-weight:bold;text-align: left">
		                		${bizCategory.categoryName}
		                		<#if bizCategory.categoryId == 1>
		                			-[指定区间日期，不可选]
		                		<#elseif bizCategory.categoryId ==16 || bizCategory.categoryId ==11 || bizCategory.categoryId ==12 || bizCategory.categoryId ==13>
		                			-[区间日期，可选]
		                		<#elseif bizCategory.categoryId ==16>
		                			-[区间日期，可选]
		                		<#else>
		                			-[指定日，不可选]
		                		</#if>
		                	</td>
		                	<td class="e_label" width="10px" style="font-weight:bold;text-align: center">
		                		行程天数：${routeNum}天${ stayNum}晚
		                	</td>
		                	<#if prodProduct.subCategoryId==182 && prodProduct.productType=='INNERLINE'&& groupType == 'LINE'  && bizCategory.categoryId ==15 >
		                     <td class="e_label" width="20px" style="text-align: right;"><a class="btn btn_cc1"  disabled="disabled" selectCategoryId="${bizCategory.categoryId}">插入时间段</a></td>
		                    <#else>
		                     <td class="e_label" width="20px" style="text-align: right;"><a class="btn btn_cc1"  onclick="addGroup('${bizCategory.categoryId}')" selectCategoryId="${bizCategory.categoryId}">插入时间段</a></td>
		                    </#if> 
		                </tr>
	                	</tbody>
	                </table>
	            </div>
	            <div >
	            </#if>
	                <table  style="width: 1054px">
	                    <tbody>
	                     <#if packGroupList?? && groupType??>
	                     	<#if groupType == 'HOTEL'>
	    						<#list packGroupList as packGroup> 
	    							<#if packGroup?? && packGroup.prodPackageGroupHotel??>
	    								<tr >
						                	<td  style="font-weight:bold;text-align: left;width:700px">
						                	    <#assign days = packGroup.prodPackageGroupHotel.stayDays?split(',')>
						                		第 ${days[0]} 晚——第 ${days[days?size-1]} 晚 【备注：${packGroup.prodPackageGroupHotel.remark}】
						                	</td>
						                	<td  style="text-align: right">
						                		<a class="btn btn_cc1" onclick="selectPackGroupProductBranch('${packGroup.groupId }','${bizCategory.categoryId}')" >选择产品</a>
												<a class="btn btn_cc1" onclick="deletePackGroup('${packGroup.groupId }')">删除该段</a>
						                	</td>
						                </tr>
						                <tr>
						                	<td colspan="2">
											  <div class="p_box box_info">
											    <table class="p_table table_center" style="width: 1055px">
									                <thead>
									                    <th>产品类型</th>
									                    <th>产品ID</th>
									                    <th>产品名称</th>
									                    <th>行政区划</th>
									                    <th>规格ID</th>
									                    <th>规格</th>
									                    <th class="freedomRouteGoodsPackageGoodsName">商品名称</th>
									                    <th>销售价规则</th>
									                    <th>状态</th>
									                    <th>优先显示</th>
									                    <th>操作</th>
									                    </tr>
									                </thead>
									                 <tbody>
															<#list packGroup.prodPackageDetails as detail> 
																<#if detail?? && detail.prodProductBranch??>
																	<tr>
																		<td >${detail.prodProductBranch.categoryName!''}</td>
																		<td>${detail.prodProductBranch.productId!''}</td>
																		<td>
																			<a style="cursor:pointer" 
																				onclick="openHotelProduct(${detail.prodProductBranch.productId!''},${detail.prodProductBranch.categoryId!''},'${detail.prodProductBranch.categoryName!''}','${hotelOnLineFlag}')">
																				${detail.prodProductBranch.productName!''}
																			</a>
																		</td>
																		<td>${detail.prodProductBranch.districtName!''}</td>
																		<td>${detail.prodProductBranch.productBranchId!''}</td>
																		<td>${detail.prodProductBranch.branchName!''}</td>
																		<td class="freedomRouteGoodsPackageGoodsName">
																		<label class="content js_content">${detail.prodProductBranch.wetherSystemLogic!''}</label>
																		<label class="content_dtl">
																		<#list detail.prodProductBranch.goodsDataList as goodsList>
											                                   <label><#if goodsList_index gt 0>;</#if>${goodsList.goodsName!''}</label>
																		</#list>
																		</label>
																		</td>
																		<td>
																			<#if detail.priceType?? && detail.priceType == 'FIXED_PRICE'>
																				加价：${detail.price/100}
																			</#if>
																			<#if detail.priceType?? && detail.priceType == 'MAKEUP_PRICE'>
																				利润：${detail.price/100}%
																			</#if>
																			<#if detail.priceType?? && detail.priceType == 'FIXED_PERCENT'>
																				加价：${detail.price/100}%
																			</#if>
																			</td>
																		<td>
																			[${cancelFlag[detail.prodProductBranch.cancelFlag]}]
																			[${saleFlag[detail.prodProductBranch.saleFlag]}]
																		</td>
																		<td>
																			<#if detail.isShowFirst == "Y">
																			是
																			<#else>
																			否
																			</#if>
																		</td>
																		<td>
																		<a class="freedomRouteGoodsPackageMethod" style="cursor:pointer" onclick="openBranchGoodForm('${detail.prodProductBranch.productBranchId!''}','${detail.prodProductBranch.branchName!''}','${detail.prodProductBranch.categoryId!''}','${detail.detailId !''}','${detail.prodProductBranch.productId!''}')">打包商品</a>
																			<a id="setPriceRule" style="cursor:pointer" onclick="updatePackGroupDetail('${detail.detailId !''}')">设置价格规则</a>
																			<a id="deletePackGroupDetail" style="cursor:pointer" onclick="deletePackGroupDetail('${detail.detailId !''}')">取消打包</a>
																			<#if prodProduct?? && (prodProduct.bizCategoryId == '15' || (prodProduct.bizCategoryId == '18' && prodProduct.subCategoryId != '181'))>
																				<a id="setPriceRule" style="cursor:pointer;" onclick="updatePackHotelGroupDetailAddPrice('${detail.detailId !''}')">设置特殊价格规则</a>
																				<a id="setPriceRule" style="cursor:pointer;" onclick="deletePackHotelGroupDetailAddPrice('${detail.detailId !''}')">删除特殊价格</a>
																			<!-- 出境 || 目的地 -->
																			<#elseif prodProduct?? && (prodProduct.bu == 'OUTBOUND_BU' || prodProduct.bu == 'DESTINATION_BU')>
																				<a id="setPriceRule" style="cursor:pointer" onclick="updatePackGroupDetailAddPrice('${detail.detailId !''}')">设置特殊价格规则</a>
																			</#if>
																			<#if prodProduct.bizCategory.categoryId==18&&prodProduct.subCategoryId=='181'&&packGroup.groupType=='HOTEL'>
																				<#if detail.isShowFirst == "Y">
																					<a href="javascript:void(0);" style="cursor:pointer" class="firstFlag" data2="${detail.detailId!''}" data=${detail.isShowFirst}>取消优先显示</a>
																				<#else>
																					<a href="javascript:void(0);" style="cursor:pointer" class="firstFlag" data2="${detail.detailId!''}" data=${detail.isShowFirst}>设置优先显示</a>
																				</#if>
																			</#if>
																		</td>
																	</tr>
																	</#if>
															</#list>
										                </tbody>
									               </table>
									               </div>
						                	</td>
						                </tr>						                
	    							</#if>
	    							
	    						 </#list>
					          </#if>
					          <!-- 线路 -->
					          <#if groupType == 'LINE' >
	    						<#list packGroupList as packGroup>
	    							<#if packGroup ?? && packGroup.prodPackageGroupLine??>
	    								<#if packGroup.categoryId ?? && packGroup.categoryId == bizCategory.categoryId>
	    								<tr>
						                	<td style="font-weight:bold;text-align: left;width:700px">
						                		第&nbsp;${packGroup.prodPackageGroupLine.startDay}&nbsp;天
						                		 ${packGroup.prodPackageGroupLine.travelDays}天 ${packGroup.prodPackageGroupLine.stayDays}晚 
						                	【备注：${packGroup.prodPackageGroupLine.remark}】
						                	</td>
						                	<td style="text-align: right">
						                	<#if prodProduct.subCategoryId==182 && prodProduct.productType=='INNERLINE'&& groupType == 'LINE'  && bizCategory.categoryId ==15>
		                                       <a class="btn btn_cc1"  disabled="disabled" >选择产品</a>
		                                    <#else>
						                		<a class="btn btn_cc1" onclick="selectPackGroupProductBranch('${packGroup.groupId }','${bizCategory.categoryId}')" >选择产品</a>
											</#if>
												<a class="btn btn_cc1" onclick="deletePackGroup('${packGroup.groupId }')">删除该段</a>
						                	</td>
						                </tr>
						                <tr>
						                	<td colspan="2">
											  <div class="p_box box_info">
											    <table class="p_table table_center" style="width: 1054px">
									                <thead>
									                    <th>产品类型</th>
									                    <th>产品ID</th>
									                    <th>产品名称</th>
									                    <th>规格ID</th>
									                    <th>规格</th>
									                    <th>销售价规则</th>
									                    <th>状态</th>
									                    <th>操作</th>
									                    </tr>
									                </thead>
									                 	<#if packGroup.prodPackageDetails ??>
															<#list packGroup.prodPackageDetails as detail> 
																<#if detail?? && detail.prodProductBranch??>
																	<tr >
																		<td >${detail.prodProductBranch.categoryName!''}</td>
																		<td>${detail.prodProductBranch.productId!''}</td>
																		<td>
																			<a style="cursor:pointer" 
																				onclick="openProduct(${detail.prodProductBranch.productId!''},${detail.prodProductBranch.categoryId!''},'${detail.prodProductBranch.categoryName!''}')">
																				${detail.prodProductBranch.productName!''}
																			</a>
																		</td>
																		<td>${detail.prodProductBranch.productBranchId!''}</td>
																		<td>${detail.prodProductBranch.branchName!''}</td>
																		<td>
																			<#if detail.priceType?? && detail.priceType == 'FIXED_PRICE'>
																				加价：${detail.price/100}
																			</#if>
																			<#if detail.priceType?? && detail.priceType == 'MAKEUP_PRICE'>
																				利润：${detail.price/100}%
																			</#if>
																			</td>
																		<td>
																			[${cancelFlag[detail.prodProductBranch.cancelFlag]}]
																			[${saleFlag[detail.prodProductBranch.saleFlag]}]
																		</td>
																		<td>
																			<a id="setPriceRule" style="cursor:pointer" onclick="updatePackGroupDetail('${detail.detailId !''}')">设置价格规则</a>
																			<a id="deletePackGroupDetail" style="cursor:pointer" onclick="deletePackGroupDetail('${detail.detailId !''}')">取消打包</a>
																			<#if detail.associatedFlag?? && detail.associatedFlag != "false">
																			<a id="setReference" style="cursor:pointer" onclick="updatePackGroupDetail('${detail.detailId !''}')">设置关联</a>
																			</#if>
																			<#if prodProduct?? && (prodProduct.bizCategoryId==15 || prodProduct.bu == 'OUTBOUND_BU' || prodProduct.bu == 'DESTINATION_BU')>
																				<a id="setPriceRule" style="cursor:pointer" onclick="updatePackGroupDetailAddPrice('${detail.detailId !''}')">设置特殊价格规则</a>
																			</#if>
																		</td>
																	</tr>
																</#if>
																
															</#list>
														  </#if>
										                </tbody>
									               </table>
									            </div>
						                	</td>
						                </tr>
						                </#if>
	    							</#if>
	    						 </#list>
					          </#if>
					          <!-- 线路结束 -->
					          <!-- 门票开始 -->
					          <#if groupType == 'LINE_TICKET' >
	    						<#list packGroupList as packGroup>
	    							<#if packGroup ?? && packGroup.prodPackageGroupTicket??>
	    								<#if packGroup.categoryId ?? && packGroup.categoryId == bizCategory.categoryId>
	    								<tr>
						                	<td  style="font-weight:bold;text-align: left;width:700px">
						                		第&nbsp;${packGroup.prodPackageGroupTicket.startDay}&nbsp;天 
						                	【备注：${packGroup.prodPackageGroupTicket.remark}】
						                	</td>
						                	<td style="text-align: right">
						                		<a class="btn btn_cc1" onclick="selectPackGroupProductBranch('${packGroup.groupId }','${bizCategory.categoryId}')" >选择产品</a>
												<a class="btn btn_cc1" onclick="deletePackGroup('${packGroup.groupId }')">删除该段</a>
						                	</td>
						                </tr>
						                <tr>
						                	<td colspan="2">
											  <div class="p_box box_info">
											    <table class="p_table table_center" style="width: 1054px">
									                <thead>
									                    <th>产品类型</th>
									                    <th>产品ID</th>
									                    <th>产品名称</th>
									                    <th>规格ID</th>
									                    <th>规格</th>
									                    <th class="freedomRouteGoodsPackageGoodsName">商品名称</th>
									                    <th>销售价规则</th>
									                    <th>状态</th>
									                    <th>操作</th>
									                    </tr>
									                </thead>
									                 	<#if packGroup.prodPackageDetails ??>
															<#list packGroup.prodPackageDetails as detail> 
																<#if detail?? && detail.prodProductBranch??>
																	<tr >
																		<td >${detail.prodProductBranch.categoryName!''}</td>
																		<td>${detail.prodProductBranch.productId!''}</td>
																		<td>																		
																			<a style="cursor:pointer" 
																				onclick="openProduct(${detail.prodProductBranch.productId!''},${detail.prodProductBranch.categoryId!''},'${detail.prodProductBranch.categoryName!''}')">
																				${detail.prodProductBranch.productName!''}
																			</a>
																		</td>
																		<td>${detail.prodProductBranch.productBranchId!''}</td>
																		<td>${detail.prodProductBranch.branchName!''}</td>
																		<td class="freedomRouteGoodsPackageGoodsName">
																		 <label class="content js_content">${detail.prodProductBranch.wetherSystemLogic!''}</label>
																		<label class="content_dtl">
																		<#list detail.prodProductBranch.goodsDataList as goodsList>
											                                   <label><#if goodsList_index gt 0>;</#if>${goodsList.goodsName!''}</label>
																		</#list>
																		</label>
																		</td>
																		<td>
																			<#if detail.priceType?? && detail.priceType == 'FIXED_PRICE'>
																				加价：${detail.price/100}
																			</#if>
																			<#if detail.priceType?? && detail.priceType == 'MAKEUP_PRICE'>
																				利润：${detail.price/100}%
																			</#if>
																			</td>
																		<td>
																			[${cancelFlag[detail.prodProductBranch.cancelFlag]}]
																			[${saleFlag[detail.prodProductBranch.saleFlag]}]
																		</td>
																		<td>
																			<a class="freedomRouteGoodsPackageMethod" style="cursor:pointer" onclick="openBranchGoodForm('${detail.prodProductBranch.productBranchId!''}','${detail.prodProductBranch.branchName!''}','${detail.prodProductBranch.categoryId!''}','${detail.detailId !''}','${detail.prodProductBranch.productId!''}')">打包商品</a>
																			<a id="setPriceRule" style="cursor:pointer" onclick="updatePackGroupDetail('${detail.detailId !''}')">设置价格规则</a>
																			<a id="deletePackGroupDetail" style="cursor:pointer" onclick="deletePackGroupDetail('${detail.detailId !''}')">取消打包</a>
																			<!-- 出境 -->
																			<#if prodProduct?? && (prodProduct.bu == 'OUTBOUND_BU' || prodProduct.bu == 'DESTINATION_BU')>
																				<a id="setPriceRule" style="cursor:pointer" onclick="updatePackGroupDetailAddPrice('${detail.detailId !''}')">设置特殊价格规则</a>
																			</#if>
																		</td>
																	</tr>
																</#if>
																
															</#list>
														  </#if>
										                </tbody>
									               </table>
									            </div>
						                	</td>
						                </tr>
						                </#if>
	    							</#if>
	    						 </#list>
					          </#if>	
					          <!-- 门票结束 -->
					          <!-- 大交通开始 -->
					          <#if groupType == 'TRANSPORT' >
	    						<#list packGroupList as packGroup>
	    							<#if packGroup ?? && packGroup.prodPackageGroupTicket??>
	    								<#if packGroup.categoryId ?? && packGroup.categoryId == bizCategory.categoryId>
	    								<tr>
						                	<td  style="font-weight:bold;text-align: left;width:700px">
						                		第&nbsp;${packGroup.prodPackageGroupTicket.startDay}&nbsp;天 
						                	【备注：${packGroup.prodPackageGroupTicket.remark}】
						                	</td>
						                	<td style="text-align: right">
						                		<a class="btn btn_cc1" onclick="selectPackGroupProductBranch('${packGroup.groupId }','${bizCategory.categoryId}')" >选择产品</a>
												<a class="btn btn_cc1" onclick="deletePackGroup('${packGroup.groupId }')">删除该段</a>
						                	</td>
						                </tr>
						                <tr>
						                	<td colspan="2">
											  <div class="p_box box_info">
											    <table class="p_table table_center" style="width: 1054px">
									                <thead>
									                    <th>产品类型</th>
									                    <th>产品ID</th>
									                    <th>产品名称</th>
									                    <th>规格ID</th>
									                    <th>规格</th>
									                    <th>销售价规则</th>
									                    <th>状态</th>
									                    <th>操作</th>
									                    </tr>
									                </thead>
									                 	<#if packGroup.prodPackageDetails ??>
															<#list packGroup.prodPackageDetails as detail> 
																<#if detail?? && detail.prodProductBranch??>
																	<tr >
																		<td >${detail.prodProductBranch.categoryName!''}</td>
																		<td>${detail.prodProductBranch.productId!''}</td>
																		<td>																		
																			<a style="cursor:pointer" 
																				onclick="openProduct(${detail.prodProductBranch.productId!''},${detail.prodProductBranch.categoryId!''},'${detail.prodProductBranch.categoryName!''}')">
																				${detail.prodProductBranch.productName!''}
																			</a>
																		</td>
																		<td>${detail.prodProductBranch.productBranchId!''}</td>
																		<td>${detail.prodProductBranch.branchName!''}</td>
																		<td>
																			<#if detail.priceType?? && detail.priceType == 'FIXED_PRICE'>
																				加价：${detail.price/100}
																			</#if>
																			<#if detail.priceType?? && detail.priceType == 'MAKEUP_PRICE'>
																				利润：${detail.price/100}%
																			</#if>
																			</td>
																		<td>
																			[${cancelFlag[detail.prodProductBranch.cancelFlag]}]
																			[${saleFlag[detail.prodProductBranch.saleFlag]}]
																		</td>
																		<td>
																			<a id="setPriceRule" style="cursor:pointer" onclick="updatePackGroupDetail('${detail.detailId !''}')">设置价格规则</a>
																			<a id="deletePackGroupDetail" style="cursor:pointer" onclick="deletePackGroupDetail('${detail.detailId !''}')">取消打包</a>
																			<!-- 出境 -->
																			<#if prodProduct?? && prodProduct.bu == 'OUTBOUND_BU'>
																				<a id="setPriceRule" style="cursor:pointer" onclick="updatePackGroupDetailAddPrice('${detail.detailId !''}')">设置特殊价格规则</a>
																			</#if>
																		</td>
																	</tr>
																</#if>
																
															</#list>
														  </#if>
										                </tbody>
									               </table>
									            </div>
						                	</td>
						                </tr>
						                </#if>
						                <!-- 大交通结束 -->
	    							</#if>
	    						 </#list>
					          </#if>	
				         </#if>
	                	</tbody>
	                </table>
	            </div>
	        </div>
        </#list>
	</#if>
</form>
<div class="fl operate">
	<a href="javascript:void(0);"  class="showLogDialog btn btn_cc1" param='objectId=${productId}&objectType=PROD_PRODUCT_PRODUCT_GROUP&sysName=VST'>操作日志</a>
</div>
</div>
<#include "/base/foot.ftl"/>
<div class="poptip">
    <div class="c_dtl"></div>
    <a href="javascript:;" class="close js_pop_close">×</a>
</div>
</body>
</html>
<script>

    var addGroupDialog, selectProductDialog,updateGroupDetailDialog,updateGroupDetailAddPriceDialog;

    function addGroup(selectCategoryId){
        $.ajax({
            url : "/vst_admin/productPack/line/isBoundStamp.do",
            type : "post",
            dataType : 'json',
            data : "productId=" + $("#productId").val(),
            success : function(result) {
                if(result.code == "success"){
                    if(result.attributes.boundStampFalg){
                        var url = "/vst_admin/productPack/line/showAddGroup.do?groupType=" +  $("#groupType").val() + "&productId=" + $("#productId").val();
                        url += "&selectCategoryId=" + selectCategoryId + "&routeNum=" + $("#routeNum").val() + "&stayNum=" + $("#stayNum").val();
                        addGroupDialog = new xDialog(url,{},{title:"新增组",iframe:true,width:"600",height:"600"});
                    }else{
                        alert("该产品下有有效预售券，不能更改!");
                    }
                }
            },
            error : function(result) {
                $.alert(result.message);
            }
        });

    }

    //取消打包
    function deletePackGroupDetail(detailId) {
        $.ajax({
            url: "/vst_admin/productPack/line/isBoundStamp.do",
            type: "post",
            dataType: 'json',
            async: false,
            data: "productId=" + $("#productId").val(),
            success: function (result) {
            debugger;
                if (result.code == "success") {
                    if (result.attributes.boundStampFalg) {
                        $.confirm("确认取消吗 ？", function () {
                            var loading = top.pandora.loading("正在努力中...");
                            $.ajax({
                                url: "/vst_admin/productPack/line/deletePackGroupDetail.do",
                                type: "post",
                                dataType: 'json',
                                data: "detailId=" + detailId + "&productId=" + $("#productId").val(),
                                success: function (result) {
                                    loading.close();
                                    if (result.code == "success") {
                                        //window.location.reload();
                                         lv_reload();
                                    }
                                },
                                error: function (result) {
                                    loading.close();
                                    $.alert(result.message);
                                }
                            });
                        });
                    } else {
                        alert("该产品下有有效预售券，不能更改!");
                    }
                }
            },
            error: function (result) {
                $.alert(result.message);
            }
        });
    }

function deletePackGroup(groupId){
 $.ajax({
			url : "/vst_admin/productPack/line/isBoundStamp.do",
			type : "post",
			dataType : 'json',
			async: false,
			data : "productId=" + $("#productId").val(),
			success : function(result) {
        		if(result.code == "success"){
        		if(result.attributes.boundStampFalg){
        	      $.confirm("确认删除吗 ？",function(){
        		  var loading = top.pandora.loading("正在努力中...");
        		  $.ajax({
        			url : "/vst_admin/productPack/line/deletePackGroup.do",
        			type : "post",
        			dataType : 'json',
        			data : "groupId=" + groupId + "&groupType=" + $("#groupType").val()+ "&productId=" + $("#productId").val(),
        			success : function(result) {
        				loading.close();
        				if(result.code == "success"){
        					//window.location.reload();
        					 lv_reload();
        				}
        			},
        			error : function(result) {
        				loading.close();
        				$.alert(result.message);
        			}
        		   });
        	     });
        	    }else{
        	       alert("该产品下有有效预售券，不能更改!");
        	      }
        		 }
		},
		error : function(result) {
			$.alert(result.message);
		}
	});
}

    /**
     * 加入产品规格
     */
    function selectPackGroupProductBranch(groupId,selectCategoryId){
        //var groupType = $(window.parent.document).find("#groupType").val();
        var groupType =$("#groupType").val();
        var categoryParentId = $("#categoryParentId").val();
        var productType = $("#productType").val();
        var BU = $("#BU").val();
        var categoryId = $("#categoryId").val();
        var url = "/vst_admin/productPack/line/showSelectProductList.do?groupType=" + groupType + "&groupId=" + groupId
                + "&selectParentCategoryFlag=" + $("#selectParentCategoryFlag").val() + "&subCategoryId="+$("#subCategoryId").val()
                + "&selectCategoryId=" + selectCategoryId
                + "&productType=" + productType
                + "&BU=" + BU
                + "&categoryId_=" + categoryId;
        if(groupType != 'HOTEL'){
            url += "&categoryParentId=" + categoryParentId;
        }
        if(groupType = 'HOTEL'){
            url += "&bizCategoryId=" + "${prodProduct.bizCategoryId!''}";
        }
        selectProductDialog = new xDialog(url,{},{title:"选择产品",iframe:true,width : "1000px", height : "1100px"});
    }

//设置单条记录价格规则
function updatePackGroupDetail(detailId){
	var groupType = $("#groupType").val();
	var url = "/vst_admin/productPack/line/showSingleUpdateGroupDetail.do?groupType=" + groupType + "&detailIds=" + detailId;
	updateGroupDetailDialog = new xDialog(url,{},{title:"设置价格规则",iframe:true,width:"600",height:"600"});	
}
    /*
    function deletePackGroup(groupId){
        $.ajax({
            url : "/vst_admin/productPack/line/isBoundStamp.do",
            type : "post",
            dataType : 'json',
            async: false,
            data : "productId=" + $("#productId").val(),
            success : function(result) {
                if(result.code == "success"){
                    if(result.attributes.boundStampFalg){
                        $.confirm("确认删除吗 ？",function(){
                            var loading = top.pandora.loading("正在努力中...");
                            $.ajax({
                                url : "/vst_admin/productPack/line/deletePackGroup.do",
                                type : "post",
                                dataType : 'json',
                                data : "groupId=" + groupId + "&groupType=" + $(window.parent.document).find("#groupType").val()+ "&productId=" + $("#productId").val(),
                                success : function(result) {
                                    loading.close();
                                    if(result.code == "success"){
                                        //window.location.reload();
                                         lv_reload();
                                    }
                                },
                                error : function(result) {
                                    loading.close();
                                    $.alert(result.message);
                                }
                            });
                        });
                    }else{
                        alert("该产品下有有效预售券，不能更改!");
                    }
                }
            },
            error : function(result) {
                $.alert(result.message);
            }
        });
    }
*/

    //保存时间段
    var groupId = '';
    function onSavePackGroup(params){
        if(params != null){
            groupId = params.groupId;
            var groupType = params.groupType;
            if(groupType == 'HOTEL'){
                $("#categoryParentId").val();
            }
            /*var selectCategoryId = params.selectCategoryId;
            var url = "/vst_admin/productPack/line/showSelectProductList.do?groupType=" + groupType + "&groupId=" + groupId
                        + "&selectParentCategoryFlag=" + $("#selectParentCategoryFlag").val()
                        + "&selectCategoryId=" + selectCategoryId;
            selectProductDialog = new xDialog(url,{},{title:"选择产品",iframe:true,width:"1000",height:"600"}); */
        }
        addGroupDialog.close();
        window.location.reload();
    }

    //关联规格与产品或者商品
    function onSavePackGroupDetail(params){
        if(params != null){
            var groupId = params.groupId;
            var groupType = params.groupType;
            var selectCategoryId = params.selectCategoryId;
            var detailIds = params.detailIds;
            var productId = $("#productId").val();
            var url = "/vst_admin/productPack/line/showUpdateGroupDetail.do?groupType=" + groupType + "&groupId=" + groupId
                    + "&selectCategoryId=" + selectCategoryId+ "&detailIds=" + detailIds + "&productId=" + productId;
            updateGroupDetailDialog = new xDialog(url,{},{title:"设置价格规则",iframe:true,width:"600",height:"600"});
            window.force_popup_toast=true;
        }

        selectProductDialog.close();
    }

    //设置单条记录价格规则
    /*function updatePackGroupDetail(detailId){
        var groupType = $(window.parent.document).find("#groupType").val();
        var url = "/vst_admin/productPack/line/showSingleUpdateGroupDetail.do?groupType=" + groupType + "&detailIds=" + detailId;
        updateGroupDetailDialog = new xDialog(url,{},{title:"设置价格规则",iframe:true,width:"600",height:"600"});
    }*/

    //设置单条记录特殊价格规则
    function updatePackGroupDetailAddPrice(detailId){
        var groupType = $("#groupType").val();
        var url = "/vst_admin/productPack/line/showSingleUpdateGroupDetailAddPrice.do?groupType=" + groupType + "&detailIds=" + detailId;
        updateGroupDetailAddPriceDialog = new xDialog(url,{},{title:"设置特殊价格规则",iframe:true,width:"700",height:"700"});
    }
    //跟团游、自由行(非景酒)打包酒店设置单条记录特殊价格规则
    function updatePackHotelGroupDetailAddPrice(detailId){
        var groupType = $("#groupType").val();
        var productId = $("#productId").val();
        var url = "/vst_admin/productPack/line/showSingleUpdateHotelGroupDetailAddPrice.do?groupType=" + groupType + "&detailIds=" + detailId +"&productId=" + productId;
        updateGroupDetailAddPriceDialog = new xDialog(url,{},{title:"设置特殊价格规则",iframe:true,width:"700",height:"700"});
    }
    
    //跟团游、自由行(非景酒)打包酒店设置单条记录特殊价格规则
    function deletePackHotelGroupDetailAddPrice(detailId){
        var groupType = $("#groupType").val();
        var url = "/vst_admin/productPack/line/showDeleteHotelGroupDetailAddPrice.do?groupType=" + groupType + "&detailIds=" + detailId;
        updateGroupDetailAddPriceDialog = new xDialog(url,{},{title:"删除特殊价格",iframe:true,width:"700",height:"700"});
    }

    //设置价格规则
    function onUpdatePackGroupDetail(){
        updateGroupDetailDialog.close();
        if(window.force_popup_toast) {
        	lv_reload();
        	delete  window.force_popup_toast;
        } else {
        	window.location.reload();
        }
    }
    //设置特殊价格规则
    function onUpdatePackGroupDetailAddPrice(){
        updateGroupDetailAddPriceDialog.close();
        window.location.reload();
    }
    
    $("a.firstFlag").bind("click",function(){
		 var detailId=$(this).attr("data2");
		 var isShowFirst=$(this).attr("data") == "Y" ? "N": "Y";
		 var productId = "${productId}";
		 var url = "/vst_admin/productPack/line/updateSingleGroupDetail.do?productId="+productId+"&detailId="+detailId+"&isShowFirst="+isShowFirst+"&newDate="+new Date();
		 msg = isShowFirst == "N" ? "是否取消优先显示  ？" : "是否优先显示  ？";
		 $.confirm(msg, function () {
			 $.get(url, function(result){
		         if (result.code == "success") {
					pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
						window.location.reload();
					}});
				}else {
					pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
						//$.alert(result.message);
					}});
				}
		     });
	     });
		 return false;
	});

    function openProduct(productId, categoryId, categoryName){
        window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
    }
    
    function openHotelProduct(productId, categoryId, categoryName,hotelOnLineFlag){
    	if(hotelOnLineFlag == "true"){
    	//调用酒店新系统链接
        window.open("/lvmm_dest_back/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
    	}else{
    	//调用老链接
        window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
    	}
    }
    isView();
    //将商品打包到规格下面以后
    function showSavePackedGoodsDetail(params){
        var groupId = params.groupId;
        var groupType =$("#groupType").val();
        var selectCategoryId = params.selectCategoryId;
        var detailIds = params.detailIds;
        var message = params.message;
        if(groupType == 'HOTEL'){
            //自主打包 酒店
            $("#groupType").val("HOTEL");
            url = "/vst_admin/productPack/line/showPackList.do?productId="+$("#productId").val() + "&groupType=HOTEL";
        }else if(groupType == 'LINE_TICKET'){
            $("#groupType").val("LINE_TICKET");
            url = "/vst_admin/productPack/line/showPackList.do?productId="+$("#productId").val() + "&groupType=LINE_TICKET";
        }
        $.alert(message);
        $("#iframeMain").attr("src",url);
        selectBranchGoodsDialog.close();
        //window.location.reload();
         lv_reload();
    }

    function hideWord()
    {
        $('.js_content').each(function(){

            var str = $(this).text();
            if(str.length>8){
                var showWord=str.substring(0,8)+"...";
                $(this).text(showWord);
            }

        });
    }
    $(function(){
        showViewHide();
        hideWord();
        freedomRouteHotelGoodsPackageHidden();
    });

    function  showViewHide() {
        $(".js_content").bind("mouseover", function () {
            var $this = $(this);
            if($this.text()=="无可售商品")
            {
                $('.js_content').css.remove();
            }
            var text = $this.next().text(), offset = $this.offset();
            $(".poptip").show().css({
                top: offset.top + $this.outerHeight() + 5,
                left: offset.left
            }).find(".c_dtl").text(text);
        });
        $(".js_pop_close").bind("click", function () {
            $(".poptip").hide();
        });
    }
    //打开单笔规格酒店商品form页面
    function openBranchGoodForm(productBranchId,branchName,categoryId,detailId,productId)
    {
        //获取组产品id
        var groupProductId = $("#productId").val();
        var groupType =$("#groupType").val();
        var categoryParentId = $("#categoryParentId").val();
        var url = "/vst_admin/productPack/hotel/showProductGoodsForm.do?productBranchId="+productBranchId+"&categoryId="+categoryId+"&productId="+productId+"&branchName="+branchName+"&detailId="+detailId+"&groupType="+groupType+"&categoryParentId="+categoryParentId+"&groupProductId="+groupProductId;
        selectBranchGoodsDialog = new xDialog(url,{"branchName":branchName},{title:"选择商品",iframe:true,width : "1100px", height :"600px"});
        window.force_popup_toast=true;
    }

    //如果是自由行 就将  酒店中和门票商品显示
    function freedomRouteHotelGoodsPackageHidden()
    {
        var categoryId = $("#freedomRouteGoodsHotelPackageId").val();
        if(categoryId !=undefined && categoryId==18 && categoryId !="")
        {
            if($(".freedomRouteGoodsPackageGoodsName").length > 0)
            {
                $(".freedomRouteGoodsPackageGoodsName").css("display","table-cell");
                $(".freedomRouteGoodsPackageMethod").css("display","inline");
            }
            else{
                return true;
            }
        }else
        {
            if($(".freedomRouteGoodsPackageGoodsName").length > 0)
            {
                $(".freedomRouteGoodsPackageGoodsName").css("display","none");
                $(".freedomRouteGoodsPackageMethod").css("display","none");
            }
            else{
                return true;
            }
        }
    };
    
    
    window.lv_reload = function() {
    	/*var url = "/vst_admin/productPack/line/showPackList.do?productId="+$("#productId").val() + "&groupType=" + $("#groupType").val();
    	if(window.force_popup_toast) {
    		url = url + "&needToast=Y";
    	}
    	 window.location.href = url;
    	 */
    	 //不再产生提示，而是直接让其重新报错条款和费用说明
    	 var subCategoryId = $("#subCategoryId").val();
    	 if(kickoffClauseSettingStep && (subCategoryId && subCategoryId == 181)) {
    	    var productId = $("#productId").val();
    	    var productType = $("#productType").val();
    	 	kickoffClauseSettingStep(productId, productType);
    	 } else {
    	 	window.location.reload();
    	 }
    }
 
</script>