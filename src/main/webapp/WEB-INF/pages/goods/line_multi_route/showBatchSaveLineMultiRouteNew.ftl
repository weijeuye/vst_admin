 <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/sales-information-iframe.css"/>
    
	<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
	<link rel="stylesheet" href="/vst_admin/css/button.css" type="text/css"/>
    
</head>
<body>

<div class="add-product">

<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_customized'>
	<#assign adultChildGoods = goodsMap['adult_child_diff'] />
	<#if adultChildGoods??>
    <div class="row">
	 		<div class="col w80 mr10 text-right text-gray">成人儿童：</div>
		 		 <div class="col w650">
		 		 	
			            <label class="checkbox">
			                <input type="checkbox" id="suppGoodsId_falg" class="checkGoods adult_child" name="suppGoodsId"  value="${adultChildGoods.suppGoodsId}" data_name="${adultChildGoods.goodsName}" data_price_type="${adultChildGoods.priceType}" supplier_id="${adultChildGoods.supplierId}"/>${adultChildGoods.goodsName}[${adultChildGoods.suppGoodsId}]
			            </label>
			          
	            </div>
    </div>
     </#if> 
</#if>	
 
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_hotelcomb' || categoryCode=='category_route_customized'>
    <#assign additionList = goodsMap['addition'] />
    <#if additionList?? && additionList?size gt 0>
    <div class="row">
			<div class="col w80 mr10 text-right text-gray">附加：</div>
			<div class="col w650">
				
		 		<#list additionList as additionGoods>
		 			<label class="checkbox" <#if additionGoods.cancelFlag!='Y'>cancelFlag="Y"</#if>  >
		 			    
		 			    <input type="checkbox" class="checkGoods addition" name="suppGoodsId" value="${additionGoods.suppGoodsId}"  data_name="${additionGoods.goodsName}" data_price_type="${additionGoods.priceType}" supplier_id="${additionGoods.supplierId}"/>${additionGoods.goodsName}[${additionGoods.suppGoodsId}]
		 			</label>
		 		</#list>
		 	</div>	
	</div>
	</#if>

</#if> 
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
    <#assign upgradList = goodsMap['upgrad'] />
    <#if upgradList?? && upgradList?size gt 0 >
    <div class="row">
	 		<div class="col w80 mr10 text-right text-gray">升级：</div>
	 		<div class="col w650">
		 		
		 		<#list upgradList as upgradGoods>
		 			<label class="checkbox">
		 				<input type="checkbox" class="checkGoods upgrade" name="suppGoodsId" value="${upgradGoods.suppGoodsId}"  data_name="${upgradGoods.goodsName}" data_price_type="${upgradGoods.priceType}" supplier_id="${upgradGoods.supplierId}"/>${upgradGoods.goodsName}[${upgradGoods.suppGoodsId}]
		 			</label>
		 		</#list>
	 		</div>	
    </div>
    </#if>
</#if>	
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
	<#assign changedHotelList = goodsMap['changed_hotel'] />
	<#if changedHotelList?? && changedHotelList?size gt 0 >
  
    <div class="row">

	 		<div class="col w80 mr10 text-right text-gray">可换酒店：</div>
	 		<div class="col w650">
		 		<#list changedHotelList as changedHotelGoods>
		 			<label class="checkbox">
		 				<input type="checkbox" class="checkGoods change_hotel" name="suppGoodsId" value="${changedHotelGoods.suppGoodsId}"  data_name="${changedHotelGoods.goodsName}" data_price_type="${changedHotelGoods.priceType}" supplier_id="${changedHotelGoods.supplierId}"/>${changedHotelGoods.goodsName}[${changedHotelGoods.suppGoodsId}]
		 			</label>
		 		</#list>
	 		</div>					
    </div>
    </#if>
    
</#if>	    
<form id="timePriceForm">
    <div class="hr"></div>
    <div class="row mt10">
        <div class="col w460 ml10">
            <div class="row">
                <label class="radio">
                    <input type="radio" checked name="dateType" value="selectDate"/>
                    选择日期
                </label>
            </div>
            <div class="JS_select_date"></div>
            <select class="JS_select_date_hidden" multiple id="optionDate"></select>
            
        </div>
        
        <div class="col w290">
            <div class="row">
                <label class="radio">
                    <input type="radio" name="dateType" value="selectTime"/>
                    选择时间段
                </label>
            </div>
            <div class="row">
                <div class="col w70 text-right text-gray pr10">
                    起始：
                </div>
                <div class="col w150">
                    <input type="text" class="datetime form-control w170 J_calendar" id="d4321" name="startDate" />
                </div>
            </div>
            <div class="row">
                <div class="col w70 text-right text-gray pr10">
                    结束：
                </div>
                <div class="col w150">
                    <input type="text" class="datetime form-control w170 J_calendar" id="d4322" name="endDate"/>
                </div>
            </div>
            <div class="row JS_checkbox_select_all_box">
                <div class="col w70 text-right text-gray pr10">
                    适应日期：
                </div>
                <div class="col w100">
                    <label>
                        <input type="checkbox" class="JS_checkbox_select_all_switch" name="weekDayAll"/>
                        全部
                    </label>
                </div>
                <div class="col week-group">
                    <p>
                        <label>
                            <input type="checkbox" class="JS_checkbox_select_all_item"  name="weekDay" value="2"/>
                            周一
                        </label>
                    </p>

                    <p>
                        <label>
                            <input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="3"/>
                            周二
                        </label>
                    </p>

                    <p>
                        <label>
                            <input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="4"/>
                            周三
                        </label>
                    </p>

                    <p>
                        <label>
                            <input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="5"/>
                            周四
                        </label>
                    </p>

                    <p>
                        <label>
                            <input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="6"/>
                            周五
                        </label>
                    </p>

                    <p>
                        <label>
                            <input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="7"/>
                            周六
                        </label>
                    </p>

                    <p>
                        <label>
                            <input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="1"/>
                            周日
                        </label>
                    </p>
                </div>
            </div>
        </div>
    </div>
	<input type="hidden" name="isSetPrice">
    <input type="hidden" name="isSetStock">
    <input type="hidden" name="isSetAheadBookTime">
    <input type="hidden" name="adult" id="adult">
    <input type="hidden" name="child" id="child">
    <input type="hidden" name="gap" id="gap">
    <input type="hidden" name="productType" value='${productType}'>
    <input type="hidden" name="packageType" value='${packageType}'>
    <input type="hidden" name="categoryCode" value='${categoryCode}'>
    <input type="hidden" name="categoryId" value='${categoryId}'>
	<input type="hidden" name="cancelStrategy" id="cancelStrategy">
	<div style="display:none" id="timePriceFormContent"></div>
	<div style="display:none" id="upDocLastTimeContent"></div>
</form>

	<form id="timePriceFormInput">
    <div>
        <ul class="nav-tabs JS_tab_main">
            <li class="active">设置库存</li>
            <li>设置价格</li>            
            <li>设置提前预定时间</li>
            <#if productType=='FOREIGNLINE' && packageType=='SUPPLIER'>
	            <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
	            	<li id="upDoclastTimeTab">设置材料截止收取时间</li>
	            </#if>
            </#if>
            <li>设置退改规则</li>
            <li>设置适用行程</li>
            <li>设置买断价格</li>
            <li>设置预售价格</li>
        </ul>
        <div class="tab-content">
            <!--设置库存 开始-->
            <div class="tab-pane active" id="stock_set">
            	
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_customized'>
    <#assign adultChildGoods = goodsMap['adult_child_diff'] />
 			<#if adultChildGoods??>
			    <div class="row JS_radio_switch_group" goodsId="${adultChildGoods.suppGoodsId}" data="stockDiv">
			    </div>
			    
			</#if>
			 
			    			    
</#if>


<!--附加库存模板-->

<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_hotelcomb' || categoryCode=='category_route_customized'>

				<#assign additionList = goodsMap['addition'] />
		 		<#list additionList as additionGoods>
		 			<div class="row JS_radio_switch_group" goodsId="${additionGoods.suppGoodsId}" data="stockDiv">
		 			
			    	</div>
		 		</#list>
</#if> 
<!--升级库存模板-->
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
    <#assign upgradList = goodsMap['upgrad'] />
    <#if upgradList?? && upgradList?size gt 0 > 		
		 		<#list upgradList as upgradGoods>
					<div class="row JS_radio_switch_group" goodsId="${upgradGoods.suppGoodsId}" data="stockDiv">
		 			
			    	</div>
		 		</#list>
    
    </#if>
</#if>

<!--可换酒店库存模板-->	
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
		 		<#assign changedHotelList = goodsMap['changed_hotel'] />
		 		<#list changedHotelList as changedHotelGoods>
		 			<div class="row JS_radio_switch_group" goodsId="${changedHotelGoods.suppGoodsId}" data="stockDiv">
		 				
			    	</div>
		 		</#list>
</#if>	            	
       
            </div>
            <!--设置库存 结束-->

            <!--设置价格 开始-->
            <div class="tab-pane" id="price_set">
            
<!--成人儿童价格模板-->            
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_customized'>
    <#assign adultChildGoods = goodsMap['adult_child_diff'] />
 			<#if adultChildGoods??>
			    <div class="row" goodsId="${adultChildGoods.suppGoodsId}" data="priceDiv" divTag="adult_child_diff">
			    </div>			    
			</#if>			    			    
</#if>


<!--附加价格模板-->

<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_hotelcomb' || categoryCode=='category_route_customized'>

				<#assign additionList = goodsMap['addition'] />
		 		<#list additionList as additionGoods>
			    	<#if additionGoods??>
			    	<div class="row JS_price_group" goodsId="${additionGoods.suppGoodsId}" data="priceDiv" divTag="addition">
			    	</div>
			    	</#if>	
			    	
		 		</#list>
</#if> 
<!--升级价格模板-->
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
    <#assign upgradList = goodsMap['upgrad'] />
    <#if upgradList?? &&upgradList?size gt 0 > 		
		 		<#list upgradList as upgradGoods>
					<div class="row" goodsId="${upgradGoods.suppGoodsId}" data="priceDiv" divTag="upgrad">
			    	</div>	
		 		</#list>
    </#if>
</#if>

<!--升级可换酒店价格模板-->	
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
		 		<#assign changedHotelList = goodsMap['changed_hotel'] />
		 		<#list changedHotelList as changedHotelGoods>
		 			<div class="row" goodsId="${changedHotelGoods.suppGoodsId}" data="priceDiv" divTag="changed_hotel">
			    	</div>	
		 		</#list>
</#if>	    
                  
            </div>
            <!--设置价格 结束-->

            <!--设置提前预定时间 开始-->
            <div class="tab-pane" id="aheadBookTime_set">
            
<!--成人儿童提前预定时间模板-->            
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_customized'>
    <#assign adultChildGoods = goodsMap['adult_child_diff'] />
 			<#if adultChildGoods??>
		         <div  goodsId="${adultChildGoods.suppGoodsId}"  class="row" data="timeDiv_date" ></div>
                 <div  goodsId="${adultChildGoods.suppGoodsId}"  class="row" data="timeDiv_limit"></div>			    
			</#if>			    			    
</#if>


<!--附加提前预定时间模板-->

<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_hotelcomb' || categoryCode=='category_route_customized'>

				<#assign additionList = goodsMap['addition'] />
		 		<#list additionList as additionGoods>
			    	<#if additionGoods??>
			    	    <div  goodsId="${additionGoods.suppGoodsId}"  class="row" data="timeDiv_date" ></div>
                        <div  goodsId="${additionGoods.suppGoodsId}"  class="row" data="timeDiv_limit"></div>	
			    	</#if>	
			    	
		 		</#list>
</#if> 
<!--升级提前预定时间模板-->
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
    <#assign upgradList = goodsMap['upgrad'] />
    
		 		<#list upgradList as upgradGoods>
			    	 <div  goodsId="${upgradGoods.suppGoodsId}"  class="row" data="timeDiv_date" ></div>
                     <div  goodsId="${upgradGoods.suppGoodsId}"  class="row" data="timeDiv_limit"></div>	
		 		</#list>
</#if>

<!--升级可换酒店提前预定时间模板-->	
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
		 		<#assign changedHotelList = goodsMap['changed_hotel'] />
		 		<#list changedHotelList as changedHotelGoods>			    	
			    	 <div  goodsId="${changedHotelGoods.suppGoodsId}"  class="row" data="timeDiv_date" ></div>
                     <div  goodsId="${changedHotelGoods.suppGoodsId}"  class="row" data="timeDiv_limit"></div>
		 		</#list>
</#if>	                
            
       
            </div>
            <!--设置提前预定时间 结束-->
            
            <!--设置设置材料截止收取时间  开始-->
			<#if productType=='FOREIGNLINE' && packageType=='SUPPLIER'>
	            <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
				
	            <div class="tab-pane">
	            	<div class="row">
	            		<div class="col w110 mr10 text-right" style='word-wrap:break-word; word-break:break-all;display:block;width:100%; height:100%;'>
	            			<ul id="upDocLstMain">
							</ul>
	            		</div>
	            	</div>
	            </div>
	            
	            </#if>
            </#if>
            <!--设置设置材料截止收取时间  结束-->
            <!--设置退改规则 开始-->
            
            <div class="tab-pane">
                <div class="tip m10">
                    <span class="text-danger">注：退改规则针对所有商品有效</span>
                </div>
                <div class="row">
                    <div class="col w110 mr10 text-right text-gray">退改规则：</div>
                    <div class="col w100 pl10">
                        <label class="radio">
                            <input type="radio" checked name="retreatRule"  data="selectCancelStrategy" value="MANUALCHANGE" checked/>
                            人工退改
                        </label>
                    </div>
                    <div class="col w100">
                        <label class="radio">
                            <input type="radio" name="retreatRule" data="selectCancelStrategy" value="UNRETREATANDCHANGE"/>
                            不退不改
                        </label>
                    </div>
                </div>
            </div>
            <!--设置退改规则 结束-->

            

            <!--设置适用行程 开始-->
            <div class="tab-pane">
                <div class="tip m10">
                    <span class="text-danger">注：适用行程针对所有商品有效</span>
                </div>
                <div class="row">
                    <div class="col w110 mr10 text-right text-gray">
                        适用行程：
                    </div>
                    <div class="col w100 pl10">
                        <select class="w80 form-control" name="lineRouteId">
                        	<option value='-1'>请选择</option>
                        	
	                        <#if prodLineRoutes?? && prodLineRoutes?size &gt; 0>
	                        	<#list prodLineRoutes as prodLineRoute>
									<option value='${prodLineRoute.lineRouteId}'>${prodLineRoute.routeName}</option>
								</#list>
							</#if>
                        </select>
                    </div>
                </div>
            </div>
            <!--设置适用行程 结束-->
            
         <!--设置买断价格 开始-->
         <div class="tab-pane" id="price_set_pre">
          <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_customized'>
            <#assign adultChildGoods_pre = goodsMap['adult_child_diff'] />
		   <#if adultChildGoods??>
		      
		     <div class="row isPreMod" goodsId="${adultChildGoods.suppGoodsId}" data="priceDiv" divTag="adult_child_diff">
		     </div>			    
		  </#if>			    			    
         </#if>
       </div>
            <!--设置买断价格 结束--> 
       <!--设置预售价格 开始-->
       <div  class="tab-pane" id="Set_PreSale">
        <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_customized'>
        <#assign adultPreSaleChildGoods = goodsMap['adult_child_diff'] />
 			<#if adultPreSaleChildGoods??>
			    <div class="row" goodsId="${adultPreSaleChildGoods.suppGoodsId}" data="preSaleDiv" >
			    </div>	
			    
			</#if>
		</#if>
         
          <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
		 	<#assign changedHotelPreSaleList = goodsMap['changed_hotel'] />
		 	<#list changedHotelPreSaleList as changedHotelPreSaleGoods>
		 			<div class="row" goodsId="${changedHotelPreSaleGoods.suppGoodsId}" data="preSaleDiv" >
			    </div>		
		 	</#list>
           </#if>
           	
        </div>
         <!--设置预售价格 结束-->
        </div>
    </div>
	</form>
    <div class="hr"></div>
    <div class="row">
        <div class="btn-group text-center">
            <a class="btn btn-primary btn-lg JS_btn_save" id="timePriceSaveButton">全部保存</a>
            <a class="btn btn-lg JS_btn_cancel" id="timePriceCancelButton">取消</a>
        </div>
    </div>

</div>

<div id="allTemplates" style="display:none">
		 <!-- 多价格价格 --> 
	<div id="multiple_price_template">
		<table align="center" class="e_table form-inline" style="width:600px;" goodsid="">
             <tbody>       
				<tr>
					<td width="160" style="text-align:right;"><span>&nbsp;{{}}&nbsp;成人价&nbsp;</span></td>
					<td>结算价：<input type="text" max="999999999" name="auditSettlementPrice{index}" class="nfadd_middText adult" data="auditSettlementPrice"></td>
					<td>销售价：<input type="text" max="999999999" name="auditPrice{index}" class="nfadd_middText adult" data="auditPrice" ></td>
					<td><input id="adultjinshou" type="checkbox" class="saleAble" name="adult">禁售</td>
				</tr>
				<tr>
					<td style="text-align:right;"><span>&nbsp;儿童价&nbsp;</span></td>
					<td>结算价：<input type="text" max="999999999" name="childSettlementPrice{index}" data="childSettlementPrice" class="nfadd_middText child"></td>
					<td>销售价：<input type="text" max="999999999" name="childPrice{index}" data="childPrice" class="nfadd_middText child" ></td>
					<td><input type="checkbox" class="saleAble" name="child" id="jinshou">禁售</td>
				</tr>
				<tr>
					<td style="text-align:right;padding-left:5px;"><span>&nbsp;房差价&nbsp;</span></td>
					<td>结算价：<input type="text" max="999999999" class="nfadd_middText gap" name="grapSettlementPrice{index}" data="grapSettlementPrice"></td>
					<td>销售价：<input type="text" max="999999999" name="gapPrice{index}" class="nfadd_middText gap" data="gapPrice" ></td>
					<td><input type="checkbox" class="saleAble" name="gap">禁售</td>
				</tr>                  
            </tbody>
       </table>
	</div>
	
	<!-- 单价格 --> 
	<div id="single_price_template">
		<table align="center" class="nfadd_table" style="width:600px;" goodsId="">
             <tbody>
                <tr>
                	<td width="160" style="text-align:right;"><span>{{}}</span></td>
					<td>结算价：<input type="text" max="999999999" name="auditSettlementPrice_{index}" data="auditSettlementPrice" class="nfadd_middText adult"></td>
					<td>销售价：<input type="text" max="999999999" name="auditPrice_{index}" data="auditPrice" class="nfadd_middText adult" ></td>
					<td><input type="checkbox" class="saleAble" name="adult">禁售11</td>                	
                </tr>
            </tbody>
       </table>
	</div>
	
	
	<div id="multiple_price_template_new">

                    <div class="col w550">
                        <div class="row JS_price_group">
                            <div class="col w110 mr10 text-right text-gray">{{}}：</div>
                            <div class="col w50">成人价</div>
                            <div class="col w100">
                                <div class="form-group">
                                    <label>
                                                                                               结算：<input class="w50 form-control JS_price_settlement"
                                      data-validate="{regular:true}"
                                      data-validate-regular="{data-validate-regular}" type="text"
                                      max="999999999" name="auditSettlementPrice{index}" 
                                      data="auditSettlementPrice"
                                      data_type="is_input" goods="adult{isInput}"/>
                                    </label>
                                </div>
                            </div>
                            <div class="col w90">
                                <select class="w85 form-control JS_price_rule" name="adultPriceRule{isInput}">
                                    <option value="custom">自定义</option>
                                    <option value="fixed">固定加价</option>
                                    <option value="percent">比例加价</option>
                                    <option value="equal">结=售</option>
                                </select>
                            </div>
                            <div class="col w80">
                            <div class="form-group">
                                <input class="w50 form-control JS_price_added" data-validate="{regular:true}" name="adultReadOnlyNum{isInput}"
                                       data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" type="text"
                                        />
                                <span class="JS_price_percent">%</span>
                             </div>   
                            </div>
                            <div class="col w110">
                                <div class="form-group">
                                    <label>
                                                                                                销售：<input class="w50 form-control JS_price_selling"
	                                  data-validate="{regular:true}"
	                                  data-validate-regular="{data-validate-regular}" type="text"
	                                  max="999999999" name="auditPrice{index}"
	                        		  data="auditPrice"
	                        		  data_type="is_input" goods="adult{isInput}"
	                        		  data-validate-readonly="true"/>
                                    </label>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row JS_price_group">
                            <div class="col w110 mr10"></div>
                            <div class="col w50">儿童价</div>
                            <div class="col w100">
                                <div class="form-group">
                                    <label>
                                                                                                结算：<input class="w50 form-control JS_price_settlement"
                                      data-validate="{regular:true}"
                                      data-validate-regular="{data-validate-regular}" type="text"
                                      max="999999999" name="childSettlementPrice{index}"
                                      data="childSettlementPrice"
                                      data_type="is_input" goods="child{isInput}"/>
                                    </label>
                                </div>
                            </div>
                            <div class="col w90">
                                <select class="w85 form-control JS_price_rule" name="childPriceRule{isInput}">
                                    <option value="custom">自定义</option>
                                    <option value="fixed">固定加价</option>
                                    <option value="percent">比例加价</option>
                                    <option value="equal">结=售</option>
                                </select>
                            </div>
                            <div class="col w80">
                                <div class="form-group">
                                    <input class="w50 form-control JS_price_added" data-validate="{regular:true}" name="childReadOnlyNum{isInput}"
                                           data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" type="text"
                                            />
                                    <span class="JS_price_percent">%</span>
                                </div>
                            </div>
                            <div class="col w110">
                                <div class="form-group">
                                    <label>
                                                                                                 销售：<input class="w50 form-control JS_price_selling"
                                          data-validate="{regular:true}"
                                          data-validate-regular="{data-validate-regular}" type="text"
				                          max="999999999" name="childPrice{index}"
				                          data="childPrice"
				                          data_type="is_input" goods="child{isInput}"
				                          data-validate-readonly="true"/>
				                   </label>
                                </div>
                            </div>
                        </div>
                        <div class="row JS_price_group">
                            <div class="col w110 mr10"></div>
                            <div class="col w50">房差</div>
                            <div class="col w100">
                                <div class="form-group">
                                    <label>
                                                                                                结算：<input class="w50 form-control JS_price_settlement"
                                          data-validate="{regular:true}"
                                          data-validate-regular="{data-validate-regular}" type="text"
                                          max="999999999"  name="grapSettlementPrice{index}"  data="grapSettlementPrice" data_type="is_input" goods="gap{isInput}"/>
                                    </label>
                                </div>
                            </div>
                            <div class="col w90">
                                <select class="w85 form-control JS_price_rule">
                                    <option value="custom">自定义</option>
                                    <option value="fixed">固定加价</option>
                                    <option value="percent">比例加价</option>
                                    <option value="equal">结=售</option>
                                </select>
                            </div>
                            <div class="col w80">
                                <div class="form-group">
                                    <input class="w50 form-control JS_price_added" data-validate="{regular:true}"
                                           data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" type="text"/>
                                    <span class="JS_price_percent">%</span>
                                </div>
                            </div>
                            <div class="col w110">
                                <div class="form-group">
                                    <label>
                                                                                                 销售：<input class="w50 form-control JS_price_selling"
                                      data-validate="{regular:true}"
                                      data-validate-regular="{data-validate-regular}" type="text"
                                      max="999999999" name="gapPrice{index}" data="gapPrice" data_type="is_input" goods="gap{isInput}"
                                      data-validate-readonly="true"/>
                                    </label>
                                </div>
                            </div>
                        </div>                       
                        
                    </div>                   
                    <div class="col w180 clearfix">
                        <div class="clearfix product-lock-up">

                            <div class="col w70" style="{isShowOne}" >
                                <div class="mb10">
                                    <div class="form-group">
                                        <label class="checkbox">
                                            <input type="checkbox" class="JS_checkbox_lock_item"  name="adult" id="adult1" data="saleAble" onchange='forbidPreContorl($(this),0,"forbidSale")' goods="adult{isInput}"/>
                                            禁售
                                        </label>
                                    </div>
                                </div>
                                <div class="mb10">
                                    <div class="form-group">
                                        <label class="checkbox">
                                            <input type="checkbox" class="JS_checkbox_lock_item" name="child" id="child1" data="saleAble" onchange='forbidPreContorl($(this),1,"forbidSale")' goods="child{isInput}"/>
                                            禁售
                                        </label>
                                    </div>
                                </div>
                                <div>
                                    <div class="form-group">
                                        <label class="checkbox">
                                            <input type="checkbox" class="JS_checkbox_lock_item" name="gap" data="saleAble" onchange='forbidPreContorl($(this),2,"forbidSale")' goods="gap{isInput}"/>
                                            禁售
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="col w90"  >
                                <div class="product-lock-up-all form-group">
                                    <label>
                                        <input type="checkbox" class="JS_checkbox_lock_all" name="multiple_price_limit" data="saleAbleAll" onchange='forbidPreContorl($(this),"all","forbidSale")' goods="{isInput}"/>
                                        全部禁售
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>	
	</div>
	<div id="single_price_template_new">
		<div class="col w110 mr10 text-right text-gray" data="additionTag">{additionTag}</div>
 
            <div class="col w50">{{}}</div>
        <div class="col w100">
            <div class="form-group">
                <label>
                    结算：<input class="w50 form-control JS_price_settlement" data-validate="{regular:true}"
                              data-validate-regular="{data-validate-regular}" type="text"
                              max="999999999" name="auditSettlementPrice_{index}" data="auditSettlementPrice"  data_type="is_input" goods="adult{isInput}"/>
                </label>
            </div>
        </div>
        <div class="col w90">
            <select class="w85 form-control JS_price_rule" name="adultPriceRule{isInput}">
                <option value="custom">自定义</option>
                <option value="fixed">固定加价</option>
                <option value="percent">比例加价</option>
                <option value="equal">结=售</option>
            </select>
        </div>
        <div class="col w80">
            <div class="form-group">
                <input class="w50 form-control JS_price_added" data-validate="{regular:true}"  name="adultReadOnlyNum{isInput}"
                       data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" type="text"/>
                <span class="JS_price_percent">%</span>
            </div>
        </div>
        <div class="col w110">
            <div class="form-group">
                <label>
                   		 销售：<input class="w50 form-control JS_price_selling" data-validate="{regular:true}"
                              data-validate-regular="{data-validate-regular}" type="text"
                              max="999999999" name="auditPrice_{index}" data="auditPrice" data_type="is_input" goods="adult{isInput}"
                              data-validate-readonly="true"/>
                </label>
            </div>
        </div>
        <div class="col">
            <div class="form-group">
                <label class="checkbox">
                    <input type="checkbox" name="adult" data="saleAble" id ="adult2" goods="adult{isInput}" goodsId="{isInput}" onchange='forbidPreContorl($(this),1,"forbidSaleSingle")'/>
                  		  禁售
                 </label>
            </div>
        </div>
	</div>
    <div id="single_price_template_new_pre">
		      <div class="col w110 mr10 text-right text-gray" data="additionTag">{additionTag}</div>		             
              <div class="col w50">{{}}</div>
            <div class="col w100 isPreControlDiv{isInput}">            
                <div class="form-group">
                    <label>
                        结算：<input class="w50 form-control JS_price_settlement" data-validate="{regular:true}"
                                  data-validate-regular="{data-validate-regular}" type="text"
                                  max="999999999" name="auditSettlementPrice_pre" data="auditSettlementPrice_pre"  data_type="is_input" goods="adult{isInput}"/>
                    </label>
                </div>
            </div>
            <div class="col w90 isPreControlDiv{isInput}">
                <select class="w85 form-control JS_price_rule" name="adultPriceRule_pre">
                    <option value="custom">自定义</option>
                    <option value="fixed">固定加价</option>
                    <option value="percent">比例加价</option>
                    <option value="equal">结=售</option>
                </select>
            </div>
            <div class="col w80 isPreControlDiv{isInput}">
                <div class="form-group">
                    <input class="w50 form-control JS_price_added" data-validate="{regular:true}" name="adultReadOnlyNum_pre"
                           data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" type="text"/>
                    <span class="JS_price_percent">%</span>
                </div>
            </div>
            <div class="col w110 isPreControlDiv{isInput}">
                <div class="form-group">
                    <label>
                       		 销售：<input class="w50 form-control JS_price_selling" data-validate="{regular:true}"
                                  data-validate-regular="{data-validate-regular}" type="text"
                                  max="999999999" name="auditPrice_pre" data="auditPrice_pre" data_type="is_input" goods="adult{isInput}"
                                  data-validate-readonly="true"/>
                    </label>
                </div>
            </div>
            <div style='' div='goodControl{isInput}' >
		                   是否可预控：<input type='radio' class='closeBudgePrice' name='isPreControlPrice{isInput}' goodsId='{isInput}' value='Y' onchange='showPreDom($(this))'  />是&nbsp;
			       <input type='radio' id="radio1{isInput}" class='closeBudgePrice' name='isPreControlPrice{isInput}' goodsId='{isInput}' value='N' onchange='showPreDom($(this))' checked  />否
		    </div>
		    <div id="hideShow" class="isPreControlDiv{isInput}" div="useBudgePriceDiv{isInput}">
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;是否启用买断价：<input type='radio' value='Y' class="useBudgePrice" name='useBudgePrice{isInput}' goodsId='{isInput}'  onchange='showPreControl($(this))'   />是&nbsp;
			     <input  type='radio' value='N' class="notUseBudgePrice" name='useBudgePrice{isInput}'goodsId='{isInput}'   onchange='showPreControl($(this))' checked />否
			     <#if categoryCode=='category_route_group' || categoryCode=='category_route_local'>
	 			 	<a class="btn" id="syncPrice" style="display:none" goodsId='{isInput}'  onclick='syncBudgePrice($(this))'>价格同步</a>
	 			 </#if>
		    </div>
	</div>   
    <!-- 多价格库存 --> 
    <div id="multiple_stock_template">
       <table class="e_table form-inline" style="width:600px" goodsId="">
             <tbody>
				<tr>
					<td style="text-align:right;" width="160" rowspan="3"><span>{{}}</span></td>
					<td width="260"><label><input type="radio" class="typeSelect"  name="stockType" checked="checked" value="INQUIRE_NO_STOCK">现询-未知库存</label></td>
					<td></td>
				</tr>
				<tr>
					<td>
						<label>
							<input type="radio" class="typeSelect" name="stockType" value="INQUIRE_WITH_STOCK">现询-已知库存
						</label>
						
						<input type="text" maxlength="11" class="nfadd_middText" name="stockIncrease_{index}" disabled=disabled  />
					</td>
					<td>是否可超卖&emsp;
						<label><input type="radio" value="Y" class="oversellFlag" name="oversellFlag_{index}" checked>是</label>
						<label><input type="radio" value="N" class="oversellFlag" name="oversellFlag_{index}">否</label>
					</td>					
				</tr>
				<tr>
					<td>
						<label><input type="radio" class="typeSelect" name="stockType" value="CONTROL"/>切位/库存</label>
						<input type="text" maxlength="11" class="nfadd_middText" name="stockIncrease1_{index}" disabled=disabled />
					</td>
					<td>是否可超卖&emsp;
						<label><input type="radio" value="Y" class="oversellFlag" name="oversellFlag1_{index}" checked>是</label>
						<label><input type="radio" value="N" class="oversellFlag" name="oversellFlag1_{index}">否</label>
					</td>	
				</tr>             
             </tbody>
           </table> 
        </div>  
        
        
       <div id="multiple_stock_template_new">
       		 <div class="col w110 mr10 text-right text-gray">{{}}</div>
       <#if (productType=='INNERSHORTLINE'|| productType=='INNERLONGLINE' || productType=='INNER_BORDER_LINE' || productType=='INNERLINE' ) 
             && packageType=='SUPPLIER'
             && (categoryCode=='category_route_group'|| categoryCode=='category_route_local' ||(categoryCode=='category_route_freedom' && (subCategoryId?? &&subCategoryId!=181)))>  
                    <div class="JS_radio_switch_box">
                        <div class="col w120">
                            <label class="radio">
                                <input type="radio" class="JS_radio_switch" name="adultStock" value="INQUIRE_NO_STOCK" data="stockType" onchange='deletePreControlByType($(this))' />
                                现询
                            </label>
                        </div>
                    </div>
         <#else>
                  <div class="JS_radio_switch_box">
                        <div class="col w120">
                            <label class="radio">
                                <input type="radio" class="JS_radio_switch" name="adultStock" value="INQUIRE_NO_STOCK" data="stockType" onchange='deletePreControlByType($(this))' />
                                现询-未知库存
                            </label>
                        </div>
                    </div>
                    <div class="JS_radio_switch_box">
                        <div class="col w120">
                            <label class="radio">
                                <input type="radio" class="JS_radio_switch" name="adultStock" value="INQUIRE_WITH_STOCK" data="stockType" onchange='deletePreControlByType($(this))' />
                                现询-已知库存
                            </label>
                        </div>
                        <div class="col w80">
	                        <div class="form-group">
	                        	<input class="w40 form-control JS_radio_disabled" disabled type="text" data_name="stockIncrease_{index}" 
	                        	data-validate="{regular:true}" data-validate-regular="^\d*$" max="999999999" />
	                        </div>	
                        </div>
                    </div>
         </#if>
                    <div class="JS_radio_switch_box">
                        <div class="col w90">
                            <label class="radio">
                                <input type="radio" class="JS_radio_switch" name="adultStock" value="CONTROL" data="stockType" onchange='deletePreControlByType($(this))' />
                                切位/库存
                            </label>
                        </div>
                        <div class="col w80">
                        	<div class="form-group">
                        	<input class="w40 form-control JS_radio_disabled" disabled type="text" 
                        	data-validate="{regular:true}" data-validate-regular="^\d*$" max="999999999"/>
                        	</div>
                        </div>
                    </div>
                    <div class="col w60">可超卖：</div>
                    <div class="col w50">
                        <label class="radio">
                            <input type="radio" <#if !(productType=='FOREIGNLINE' && categoryCode=="category_route_group")> checked </#if> name="oversellFlag_{index}"  data="oversellFlag" value="N"  />
                            否
                        </label>
                    </div>
                    <div class="col w50">
                        <label class="radio mr10">
                            <input type="radio" <#if productType=='FOREIGNLINE' && categoryCode=="category_route_group"> checked </#if> name="oversellFlag_{index}" data="oversellFlag" value="Y"/>
                            是
                        </label>
                    </div>
       
       
       
       </div> 
	         
        <!-- 提前预定时间 -->  
        <div id="ahead_time_template">
 <table class="e_table form-inline" style="width:600px" goodsId="">
             <tbody>
             	<tr><td colspan="2">{{}}</td></tr>
             	<tr>
                    <td width="150" class="e_label">提前预定时间：</td>
                    <td>
                    	<input type="hidden"  name="aheadBookTime" id="aheadBookTime">
	                    	<select class="w10 mr10" name="aheadBookTime_day">
			                      <#list 0..180 as i>
			                      <option value="${i}">${i}</option>
			                      </#list>
			                </select>天
		                <select class="w10 mr10" name="aheadBookTime_hour">
		                      <#list 0..23 as i>
		                      <option value="${i}" <#if i==10>selected=selected</#if> >${i}</option>
		                      </#list>
		                </select>点
		                <select class="w10 mr10" name="aheadBookTime_minute">
		                      <#list 0..59 as i>
		                      <option value="${i}">${i}</option>
		                      </#list>
		                </select>分
                    </td>
                </tr>
                <tr >
                    <td class="e_label">预付预授权限制：</td>
                     <td>
	                    <select class="w10" name="bookLimitType" id="bookLimitType">
	                    	<#--<option value="NONE">无限制</option>-->
	                    	<#--<option value="PREAUTH">一律预授权</option>-->
	                    	<option value="NOT_PREAUTH">不使用预授权</option>
	                    </select>
                    </td>
                </tr>
            </tbody>
        </table>	         
    	</div>
		
		<div id="ahead_time_template_date_new">
                    <div class="col w110 mr10 text-right text-gray">{{}}</div>
                    <div class="col w110">提前预定时间：</div>
                    <div class="col w120">
                    <input type="hidden"  name="aheadBookTime" id="aheadBookTime">
                        <label>
		                    	<select class="w80 form-control" name="aheadBookTime_day">
		                    		  <option value="-1">请选择</option>	
				                      <#list 0..180 as i>
				                      <option value="${i}">${i}</option>
				                      </#list>
				                </select>天
                        </label>
                    </div>
                    <div class="col w120">
                        <label>
                            <select class="w80 form-control" name="aheadBookTime_hour">
                            	<!--<option value="-1">请选择</option>-->
                            	<#list 0..23 as i>
		                      		<option value="${i}">${i}</option>
		                       </#list>
                            </select>
                            	点
                        </label>
                    </div>
                    <div class="col w120">
                        <label>
                            <select class="w80 form-control" name="aheadBookTime_minute">
                            	<!--<option value="-1">请选择</option>-->
                            	<#list 0..59 as i>
		                      		<option value="${i}">${i}</option>
		                      	</#list>
                            </select>
                            	分
                        </label>
                    </div>
                
		
		</div>
		<div id="ahead_time_template_limit_new">
			<div class="col w110 mr10"></div>
                    <div class="col w110">预付预授权限制：</div>
                    <div class="col w120">
                        <select class="w80 form-control" name="bookLimitType" id="bookLimitType">
                        	<!--<option value="">请选择</option>-->
                        	<#if defaultBookLimitType=="NONE">
                        	   <#--<option value="NONE">无限制</option>-->
	                    	  <#-- <option value="PREAUTH">一律预授权</option>-->
	                    	   <option value="NOT_PREAUTH">不使用预授权</option>
                        	<#elseif defaultBookLimitType=="NOT_PREAUTH">
                        	   <option value="NOT_PREAUTH">不使用预授权</option>
                        	  <#-- <option value="NONE">无限制</option>-->
	                    	  <#-- <option value="PREAUTH">一律预授权</option>-->
                        	</#if>
                        </select>
             </div>
		</div>	
	
	<!--买断价格设置-->
	<div id="multiple_price_template_new_pre">
	    <div style='' div='goodControl{isInput}' >是否可预控：
		       <input type='radio' class='closeBudgePrice' name='isPreControlPrice{isInput}' value='Y' goodsId='{isInput}' onchange='showPreDom($(this))'   />是&nbsp;
		       <input type='radio' id="radio2{isInput}" class='closeBudgePrice' name='isPreControlPrice{isInput}' value='N' goodsId='{isInput}' onchange='showPreDom($(this))' checked />否
		</div>	
		<div id="hideshow2"class="col isPreControlDiv{isInput}" div="useBudgePriceDiv{isInput}" style="margin-bottom:10px;width:100%">
		     <lable>是否启用买断价</lable>
		     <input type='radio' value='Y' class="useBudgePrice" name='useBudgePrice{isInput}' goodsId='{isInput}'  onchange='showPreControl($(this))'  />是&nbsp;
		     <input type='radio' value='N' class="notUseBudgePrice" name='useBudgePrice{isInput}' goodsId='{isInput}' onchange='showPreControl($(this))'  checked />否&nbsp;
		     <#if categoryCode=='category_route_group' || categoryCode=='category_route_local'>
 			 	<a class="btn" id="syncPrice" style="display:none" goodsId='{isInput}'  onclick='syncBudgePrice($(this))'>价格同步</a>
 			 </#if>
		</div>
        <div class="w550 isPreControlDiv{isInput}" >
            <div class="row JS_price_group forbidSale">
                <div class="col w110 mr10 text-right text-gray">{{}}：</div>
                <div class="col w50">成人价</div>
                <div class="col w100">
                    <div class="form-group">
                        <label>
                                                                                   结算：<input class="w50 form-control JS_price_settlement"
                          data-validate="{regular:true}"
                          data-validate-regular="{data-validate-regular}" type="text"
                          max="999999999" name="auditSettlementPrice_pre" 
                          data="auditSettlementPrice_pre"
                          data_type="is_input" goods="adult{isInput}"/>
                        </label>
                    </div>
                </div>
                <div class="col w90">
                    <select class="w85 form-control JS_price_rule" name="adultPriceRule_pre">
                        <option value="custom">自定义</option>
                        <option value="fixed">固定加价</option>
                        <option value="percent">比例加价</option>
                        <option value="equal">结=售</option>
                    </select>
                </div>
                <div class="col w80">
                <div class="form-group">
                    <input class="w50 form-control JS_price_added" data-validate="{regular:true}" name="adultReadOnlyNum_pre"
                           data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" type="text"
                            />
                    <span class="JS_price_percent">%</span>
                 </div>   
                </div>
                <div class="col w110">
                    <div class="form-group">
                        <label>
                                                               销售：<input class="w50 form-control JS_price_selling"
                          data-validate="{regular:true}"
                          data-validate-regular="{data-validate-regular}" type="text"
                          max="999999999" name="auditPrice_pre"
                		  data="auditPrice_pre"
                		  data_type="is_input" goods="adult{isInput}"
                		  data-validate-readonly="true"/>
                        </label>
                    </div>
                </div>
            </div>
                        
        	<div class="row JS_price_group forbidSale">
	            <div class="col w110 mr10"></div>
	            <div class="col w50">儿童价</div>
	            <div class="col w100">
	                <div class="form-group">
	                    <label>
	                                                                                结算：<input class="w50 form-control JS_price_settlement"
	                      data-validate="{regular:true}"
	                      data-validate-regular="{data-validate-regular}" type="text"
	                      max="999999999" name="childSettlementPrice_pre"
	                      data="childSettlementPrice_pre"
	                      data_type="is_input" goods="child{isInput}"/>
	                    </label>
	                </div>
	            </div>
	            <div class="col w90">
	                <select class="w85 form-control JS_price_rule" name="childPriceRule_pre">
	                    <option value="custom">自定义</option>
	                    <option value="fixed">固定加价</option>
	                    <option value="percent">比例加价</option>
	                    <option value="equal">结=售</option>
	                </select>
	            </div>
	            <div class="col w80">
	                <div class="form-group">
	                    <input class="w50 form-control JS_price_added" data-validate="{regular:true}" name="childReadOnlyNum_pre"
	                           data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" type="text"
	                            />
	                    <span class="JS_price_percent">%</span>
	                </div>
	            </div>
	            <div class="col w110">
	                <div class="form-group">
	                    <label>
	                                                        销售：<input class="w50 form-control JS_price_selling"
	                          data-validate="{regular:true}"
	                          data-validate-regular="{data-validate-regular}" type="text"
	                          max="999999999" name="childPrice_pre"
	                          data="childPrice_pre"
	                          data_type="is_input" goods="child{isInput}"
	                          data-validate-readonly="true"/>
	                   </label>
	                </div>
	            </div>
        	</div>
     	</div>
     	<div style='width:100%' class='bindControlProject{isInput}'>
     		<div style="float:left;">绑定预控项目：</div>	
			<input type="hidden" id="resPrecontrolIds{isInput}" name="resPrecontrolIds" />
	       	<a class="btn" id="bindControlProject" style="display: inline-block;" goodsid="{isInput}" suppid="{supplierId}" onclick="bindControlProject($(this))">绑定</a>
	       	<div style="float:left;" id="selectPreControlName"></div>
		</div>
     </div>
     <!--预售价格设置-->
      <div id="multiple_preSale_template_new_preSale">
         <div class="col w110 mr10 text-right text-gray">{{}}</div>
	     <div style='' div='isPreSale{isInput}' >是否可预售：
		       <input type='radio'  name='bringPreSale{isInput}' value='Y' goodsId='{isInput}' onchange='toIsPreSale($(this))' />是&nbsp;
		       <input type='radio'  name='bringPreSale{isInput}' value='N' goodsId='{isInput}' onchange='toIsPreSale($(this))'  checked />否
		  </div>
		  <div class="col w550 isPreSaleDiv{isInput}" style="display:none;">
            <div class="row JS_price_group forbidSale">
                <div class="col w110 mr10 text-right text-gray"></div>
                <div class="col w50">成人价</div>
                <div class="col w150">
                    <div class="form-group">
                        <label>
                                                                                           结算：<input class="w100 form-control JS_price_settlement" 
                                     data-validate="{regular:true}" 
                          type="text"  data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$"
                          max="999999999" name="auditShowPreSale_pre"  data="auditShowPreSale_pre" data_type="is_input" goods="adult{isInput}" />
                        </label>
                    </div>
                </div>
               </div>
             </div>
          <div class="col w550 isPreSaleDiv{isInput}" style="display:none;">
           <div class="row JS_price_group forbidSale">
            <div class="col w110 mr10"></div>
            <div class="col w50">儿童价</div>
            <div class="col w150">
                <div class="form-group">
                    <label>
                                                                             结算：<input class="w100 form-control JS_price_settlement"  data-validate="{regular:true}"
                      type="text"  data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" 
                       max="999999999" name="childShowPreSale_pre"
                       data="childShowPreSale_pre"
                      data_type="is_input" goods="child{isInput}"/>
                    </label>
                </div>
            </div>
          </div> 
        </div>
       </div>                   
	<!---->	
	
<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/sales-information-add.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>



<script>
var categoryCode="";
<#if categoryCode=='category_route_hotelcomb'>
		//将无效的隐藏
		$("label[cancelFlag='Y']").hide();
		$("div[cancelFlag='Y']").hide();
		categoryCode = 'category_route_hotelcomb';
		$(function(){
			//批量开售或禁售事件
			$(document).delegate("input[name='branchSale']","click",function(e) {
			     var obj = e.currentTarget;
				 branchAddSaleFlag(obj);
		    });
			//批量设置结算价
		     $(document).delegate("#branchAdultSettlePrice","change",function(e) {
		        var obj = e.currentTarget;
		        branchAddAdultSettlePrice(obj);
		     });
		     //批量加价
		     $(document).delegate("#branchPriceSelect","change",function(e) {
		     var obj = e.currentTarget;
		     branchAddPriceSelect(obj);
		     });
		     $(document).delegate("#branchAddPrice","change",function(e) {
		     var obj = e.currentTarget;
		     branchAddAddPrice(obj);
		     });
		     //批量销售价赋值
		     $(document).delegate("#branchAdultPrice","change",function(e) {
		        var obj = e.currentTarget;
		        branchAddAdultPrice(obj);
		     });
		});
			function branchAddSaleFlag(obj)
			{
				//如果是批量开售
				if(obj.value=="true")
				{
					$(".onSaleFlagClass").attr("checked","true");
					$(".adultSaleFlag").val("1");
				    $(".adultSaleFlag").removeAttr("checked");
				}else if(obj.value=="false")
				{
					//如果是批量禁售
					$(".forbidSaleFlagClass").attr("checked","true");
					$(".adultSaleFlag").attr("checked","true");
					$(".adultSaleFlag").val("1");
				} 
			};
			//批量设置结算价
			function branchAddAdultSettlePrice(obj)
			{
				//结算价
				branchAdultSettlePriceValue	 = obj.value;
				//加价类型
				var branchPriceType = $("#branchPriceSelect").val();
				//加价值
				var branchAddPriceValue = $("#branchAddPrice").val();
				var flag = validataData(obj,branchAdultSettlePriceValue);
				if(flag==false){
					return;
					}
				$(".JS_price_settlement").val(branchAdultSettlePriceValue);
				if(branchPriceType=="custom"){
					$(".JS_price_settlement").val(branchAdultSettlePriceValue);
				}else if(branchPriceType=="fixed"){
					if(branchAddPriceValue!="" && branchAdultSettlePriceValue !=""){
					  salePrice = parseFloat(branchAdultSettlePriceValue)+parseFloat(branchAddPriceValue);
					  $("#branchAdultPrice").val(salePrice);
					  $(".JS_price_selling").val(salePrice);
					}else{
						 salePrice = branchAdultSettlePriceValue+branchAddPriceValue;
						  $("#branchAdultPrice").val(salePrice);
						  $(".JS_price_selling").val(salePrice);
					}
				}else if(branchPriceType=="percent"){
					//比例加价时  销售价 = 结算价+百分比
					salePrice = (branchAdultSettlePriceValue * (1 + branchAddPriceValue / 100)).toFixed(2);
					 $("#branchAdultPrice").val(salePrice);
					 $(".JS_price_selling").val(salePrice);
				}else if(branchPriceType=="equal"){
					$("#branchAdultPrice").val(branchAdultSettlePriceValue);
					 $(".JS_price_selling").val(branchAdultSettlePriceValue);
				}
			};
			//批量加价
			function branchAddPriceSelect(obj)
			{
				//加价类型
				var $objValue = $(obj).val();
				//结算价
				var branchAdultSettlePriceValue = $("#branchAdultSettlePrice").val();
				//加价值
				var branchAddPriceValue = $("#branchAddPrice").val();
				//销售价
				var branchAdultPriceValue = $("#branchAdultPrice").val();
				$(".branchPriceSelect option[value="+$objValue).attr("selected","select");
				if($objValue=="custom")
				{
				    $("#branchAddPrice").attr("readonly","true");
				    $("#branchAdultPrice").removeAttr("readonly");
				    $(".JS_price_percent").css("display","none");
				    $(".JS_price_added").attr("readonly","true");
				    $(".JS_price_selling").removeAttr("readonly");
				    $("#branchAddPrice").val("");
				    $(".JS_price_added").val("");
				    $(".JS_price_selling").val("");
				    $("#branchAdultPrice").val("");
				}else if($objValue=="fixed")
				{
					$("#branchAddPrice").removeAttr("readonly");
					$("#branchAdultPrice").attr("readonly","true");
					$(".JS_price_percent").css("display","none");
					$(".JS_price_added").removeAttr("disabled").removeAttr("readonly");
					$(".JS_price_selling").attr("readonly","true");
					$("#branchAdultPrice").val("");
					$(".JS_price_selling").val("");
					 $("#branchAddPrice").val("");
					$(".JS_price_added").val("");
					
				}else if($objValue=="percent")
				{
					//比例加价时  销售价 = 结算价+百分比
					salePrice = (branchAdultSettlePriceValue * (1 + branchAddPriceValue / 100)).toFixed(2);
					$(".JS_price_percent").css("display","inline");
					$("#branchAddPrice").removeAttr("readonly");
					$("#percentClass").removeAttr("readonly");
				    $("#branchAdultPrice").attr("readonly","true");
					$("#JS_price_selling").attr("readonly","true");
					$(".JS_price_added").removeAttr("disabled").removeAttr("readonly");
					$("#branchAdultPrice").val(salePrice);
					$(".JS_price_selling").attr("readonly","true");
					$(".JS_price_selling").val(salePrice);
				}else if($objValue=="equal")
				{
					  value = $("#branchAdultSettlePrice").val();
					  $("#branchAdultPrice").val(value);
					  $(".JS_price_selling").val(value);
					  $("#branchAddPrice").val("");
					  $(".JS_price_added").val("");
					  $("#branchAddPrice").attr("readonly","true");
					  $("#branchAdultPrice").attr("readonly","true");
					  $(".JS_price_percent").css("display","none");
					  $(".JS_price_added").attr("readonly","true");
					  $(".JS_price_selling").attr("readonly","true");			  
				}
			};
			function branchAddAddPrice(obj)
			{
				//加价类型
				branchPriceType = $("#branchPriceSelect").val();
				//结算价
				branchAdultSettlePriceValue = $("#branchAdultSettlePrice").val();
				//加价值
				var $objValue = $(obj).val();
				var flag = validataData(obj, $objValue);
				if(flag==false){
					return;
					}
				 $(".JS_price_added").val($objValue);
				if(branchPriceType=="custom"){
					return true;
				}else if(branchPriceType=="fixed"){
					if(branchAdultSettlePriceValue!="" && $objValue!="")
					{
						 salePrice = parseFloat(branchAdultSettlePriceValue)+ parseFloat($objValue);
						 $("#branchAdultPrice").val(salePrice);
						 $(".JS_price_selling").val(salePrice);
					}else{
						$("#branchAdultPrice").val("");
						 $(".JS_price_selling").val("");
						}
				}else if(branchPriceType=="percent"){
					//比例加价时  销售价 = 结算价+百分比
					salePrice = (branchAdultSettlePriceValue * (1 + $objValue / 100)).toFixed(2);
					 $("#branchAdultPrice").val(salePrice);
					 $(".JS_price_selling").val(salePrice);
				}
				 
			};
			function branchAddAdultPrice(obj)
			{
				var $objValue = $(obj).val();
				var flag = validataData(obj, $objValue);
				if(flag==false){
					return;
					}
				$(".JS_price_selling").val($objValue);
			};
			//对批量选项进行初始化
			function initializeAddBranchPrice()
			{
				$("#branchAdultSettlePrice").val("");
				$("#branchPriceSelect option[value=custom").attr("selected","select");
			    $("#branchAddPrice").attr("readonly","true");
			    $("#branchAddPrice").val("");
			    $("#branchAdultPrice").val("");
			    $("#branchAdultPrice").removeAttr("disabled").removeAttr("readonly");
			};
		 	function validataData(o,value)
			{
		 		 $("#removeWarn").remove();
	             if (typeof(o.tagName) && !isNaN(value)) {
	                $(o).val(value);
	                return true;
	             }else{
					 $(o).after("<i class='error' id='removeWarn'><span class='icon icon-danger'></span><span class='error-text'>格式不正确</span></i>");
					 return false;
					}
			};
			function onAndDownControl(obj,num)
			{
				var goodsId =  obj.attr('goodsid');
				if(num==0){
					//如果开售 
					  //如果是开售
					 $("#adultSaleFlag_"+goodsId).attr("checked",false);
					 $("#adultSaleFlag_"+goodsId).val("1");
				}else if(num==1)
				  {
				    //如果是禁售 
					  $("#adultSaleFlag_"+goodsId).attr("checked","true");
					  $("#adultSaleFlag_"+goodsId).val("1");
				  }	
			};
			function validateForbiebutton()
			{
				var i=false;
				$("input[data='saleAble']").each(function(){
				  var goodsId = $(this).attr("goodsId");
				  if(goodsId !="" && goodsId != undefined && goodsId != "{isInput}"){
					  var value = $("#adultSaleFlag_"+goodsId).val();
					  if(value !="1"){
							 i=false;
							return false;
						  }else{
							  i=true;
						  }
				  }else{
					  i=true;
				  } 
				});
				return i;
			}
</#if>

//是否买断默认隐藏


var isBudgePrice = '';
//是否设置过买断	
function toPreBudgeGoods(){
  $("input[name='suppGoodsId']:checkbox").each(function(){ 
		 if ($(this).attr("checked")=='checked') { 
			 goodsId= $(this).val();
				$.ajax({
					url:'/vst_admin/lineMultiroute/goods/timePrice/isPreBudgeGoods.do',
					data:{
						suppGoodsId:goodsId
					},
					type:"GET",
					async:false,
					dataType:"json",
					success:function(result){
					  if(result.data=='Y')
					  {
						if(!confirm("本商品已经设置为买断价格,是否重新设置商品买断?")){
						  isBudgePrice = "N";
						  return isBudgePrice;					
						}else{
						 isBudgePrice = "Y";
						 return isBudgePrice;	
						}
					  }else{
					     isBudgePrice = "Y";
					     return isBudgePrice;
					  }
					}
				 }); 
	  } 
	});
}

var checkBindPrecontrol = "N";
function preControlData(map){
    var goodsId = map["goodsId"];
    $("#resPrecontrolIds"+goodsId).val(map["resPrecontrolIds"]);
    $("#selectPreControlName",$(".bindControlProject"+goodsId)).text(map["resPrecontrolName"]);
    checkBindPrecontrol = "Y";
    $("#selectPreControlName",$(".bindControlProject"+goodsId)).show();
    $("#bindControlProject",$(".bindControlProject"+goodsId)).hide();
}

var globalIndex = 0;
var additionIndex = 0; 
var priceType = ""
//商品点击事件	
	$(".adult_child,.comb_hotel,.addition,.upgrade,.change_hotel").click(function(){
		var that = $(this);
		var name = that.attr("data_name");
		priceType = that.attr("data_price_type");
		var goodsId = that.val();
		var supplierId = that.attr("supplier_id");
		
		//单价格类型显示div标签
		var divTag="";
		var tagName="";
		if(priceType=="SINGLE_PRICE"){
				if(that.is(".comb_hotel")){
					divTag="combo_dinner";
					tagName="套餐";
				}else if(that.is(".addition")){
					divTag="addition";
					tagName="附加";
				}else if(that.is(".upgrade")){
					divTag="upgrade";
					tagName="升级";
				}else if(that.is(".change_hotel")){
					divTag="comb_hotel";
					tagName="可换酒店";
				}	
		}
		//首先判断是选中还是取消
		if(that.attr("checked")!='checked'){
			//如果是取消，则执行删除模板操作
			deleteTemplate(goodsId);
			if(priceType=="SINGLE_PRICE"){
				showCommonTag(divTag,tagName);
			}
			//判断是否清空行程选择,所有的商品都取消去掉选择
			var size = $("input[type=checkbox][name=suppGoodsId]:checked").size();
	 		if(size == 0){
	 			$("select[name=lineRouteId]").val('');
	 		}
			return;
		}
		
		//设置库存模板
		var stockTemplate = '';
		stockTemplate = $("#multiple_stock_template_new").html();
		//为模板设置商品名称
		stockTemplate = stockTemplate.replace(/{{}}/g,name);
		//修改模板radio name(防止冲突)
		stockTemplate = stockTemplate.replace(/adultStock/g,'adultStock'+globalIndex);
		//修改库存name
		stockTemplate = stockTemplate.replace(/{index}/g,globalIndex);
		//设置价格模板
		var priceTemplate = '';
		var priceTemplate_pre = '';
		var preSaleTemplate=$("#multiple_preSale_template_new_preSale").html();
		if(priceType=="SINGLE_PRICE"){
			priceTemplate = $("#single_price_template_new").html();
			priceTemplate_pre=$("#single_price_template_new_pre").html();
		}else if(priceType=="MULTIPLE_PRICE"){
			priceTemplate = $("#multiple_price_template_new").html();
			priceTemplate_pre = $("#multiple_price_template_new_pre").html();
		
		}else {
			alert("该商品未设置价格类型!");
			return;
		}
		
		if(that.is(".comb_hotel")){
			priceTemplate = priceTemplate.replace(/{isShowOne}/g,"display:none");	
			priceTemplate_pre = priceTemplate_pre.replace(/{isShowOne}/g,"display:none");
		}else{
			priceTemplate = priceTemplate.replace(/{isShowOne}/g,"");
			priceTemplate_pre = priceTemplate_pre.replace(/{isShowOne}/g,"");
		}
		
		if(that.attr("data_name")==='自备签'){
			var res = "^-?([1-9]\\d{0,8}|[1-9]\\d{0,8}\\.\\d{1,2}|0\\.\\d{1,2}|0?\\.0{1,2}|0)$"
			priceTemplate = priceTemplate.replace(/{data-validate-regular}/g,res);
			priceTemplate_pre = priceTemplate_pre.replace(/{data-validate-regular}/g,res);
		}else{
			priceTemplate = priceTemplate.replace(/{data-validate-regular}/g,"^([1-9]\\d{0,8}|[1-9]\\d{0,8}\\.\\d{1,2}|0\\.\\d{1,2}|0?\\.0{1,2}|0)$");
			priceTemplate_pre = priceTemplate_pre.replace(/{data-validate-regular}/g,"^([1-9]\\d{0,8}|[1-9]\\d{0,8}\\.\\d{1,2}|0\\.\\d{1,2}|0?\\.0{1,2}|0)$");
		}
			
		//为模板设置商品名称
		priceTemplate = priceTemplate.replace(/{{}}/g,name);
	
		priceTemplate = priceTemplate.replace(/{isInput}/g,goodsId);

		priceTemplate = priceTemplate.replace(/{index}/g,globalIndex);
		
		priceTemplate_pre = priceTemplate_pre.replace(/{{}}/g,name);
	
		priceTemplate_pre = priceTemplate_pre.replace(/{isInput}/g,goodsId);
		
		priceTemplate_pre = priceTemplate_pre.replace(/{supplierId}/g,supplierId);

		priceTemplate_pre = priceTemplate_pre.replace(/{index}/g,globalIndex);
		
		preSaleTemplate=preSaleTemplate.replace(/{isInput}/g,goodsId);
		preSaleTemplate = preSaleTemplate.replace(/{{}}/g,name);
		
		//设置提前预定时间模板
		var aheadBookTimeTemplate = '';
		aheadBookTimeTemplate +=  $("#ahead_time_template_date_new").html()+"---0ahead0---";
		aheadBookTimeTemplate +=  $("#ahead_time_template_limit_new").html();
		
		//为模板设置商品名称
		aheadBookTimeTemplate = aheadBookTimeTemplate.replace(/{{}}/g,name);
		//设置模板
		setAdultChildTemplate(goodsId,priceTemplate,stockTemplate,aheadBookTimeTemplate,priceTemplate_pre,preSaleTemplate);
		validInitPrice();
		globalIndex++;
		//$('input[type:radio][name=nfadd_price]').eq(0).click();
		
		if(priceType=="SINGLE_PRICE"){
			$("div[goodsId="+goodsId+"][data=priceDiv]").find("select").change();
			showCommonTag(divTag,tagName);
		}
		
		//222showPreDom($(":radio[name=isPreControlPrice"+goodsId+"]").eq(1));
		//showPreControl($(":radio[name=isPreControlPrice"+goodsId+"]").eq(1));
		//hidePreControl(goodsId);
	});	
	
	
	var  validateAddIsTrue = null;	
	//动态绑定页面价格库存等模板 时候,一些校验输入的交互js 需要动态加载js来获取效果
	function validInitPrice(){
			var $form = $("#timePriceFormInput");
			//表单验证
			validateAddIsTrue = backstage.validate({
			    $area: $form,
			    //$submit: $btnSave,
			    showError: true
			});
			validateAddIsTrue.start();
			validateAddIsTrue.watch();
	}
	
	
	var isBindFlag = true,showMsg = '';	
	// 保存
	$("#timePriceSaveButton").click(function(){
		var size = $("input[type=checkbox][name=suppGoodsId]:checked").size();
 		if(size == 0){
 			newAlert('请选择商品');
 			return;
 		}	
	
		if($('input[name=dateType]:checked').val()=='selectDate'){
			if($('#optionDate').find('option').size()==0){
				alert("请选择日历中日期");
				return;
			}
		}else{
			
			 if($("input[type=checkbox][name=weekDay]:checked").size()==0){
			 	alert("请选择适用日期");
			 	return;
			 }
			 if($('#d4321').val().length<=0){
			
			 	alert("请选择开始时间");
			 	return;
			 }
			 if($('#d4322').val().length<=0){
			 
			 	alert("请选择结束时间");
			 	return;			 
			 }
			 var weeks = []; 
			 $("input[type=checkbox][name=weekDay]:checked").each(function(){
				weeks.push($(this).val());
			 
			 })
			 var startDate = $('#d4321').val() ; 
			 var endDate = $('#d4322').val();
			 if(!validWeekHasDate(startDate,endDate,weeks)){
			 	alert("适应日期中不存在可用日期");
			 	return ;
			 }
			 		 			 
		}
		//如果是品类是酒店套餐 
		if(categoryCode=="category_route_hotelcomb"){
			var forbieValue = validateForbiebutton();
		  	if(forbieValue==false)
		  	{
		  		alert("请选择销售状态");
		  		return;
		  	}
		}
		
		//非空判断价格库存
	  	var nullMsg = setValidElementForm();
	  	if(nullMsg!=''){
	  		alert(nullMsg);
	  		return ; 
	  	}

        //判断跟团游所设儿童价是否小于成人价，房差是否小于等于成人价
        // 自由行所设儿童价是否小于成人价，房差是否小于成人价，一旦超出，则在保存时弹窗警示，但是不做其他限制
        if($("#suppGoodsId_falg").prop("checked")) {
            var goodsId = $("#suppGoodsId_falg").val();
            var auditPrice = $("#price_set [data='auditPrice']").val(); //成人价
            var childPrice = $("#price_set [data='childPrice']").val(); //儿童价
            var gapPrice = $("#price_set [ data='gapPrice']").val(); //房差价
            var thisCategoryId = $("[name='categoryId']").val();
            var flag = true;
            if (thisCategoryId && (thisCategoryId == "15" || thisCategoryId == "18")) {
                if (thisCategoryId == "15") {//跟团游
                    if (childPrice && auditPrice && gapPrice) {
                        if (childPrice - auditPrice > 0 && gapPrice - auditPrice >= 0) {
                            if (!confirm("儿童价大于成人价，房差大于等于成人价！是否继续？")) {
                                return;
                            } else {
                                flag = false;//继续
                            }
                        }
                    }
                    if (flag) {
                        if (childPrice && auditPrice && childPrice - auditPrice > 0) {
                            if (!confirm("儿童价大于成人价！是否继续？")) {
                                return;
                            }
                        }
                        if (gapPrice && auditPrice && gapPrice - auditPrice >= 0) {
                            if (!confirm("房差大于等于成人价！是否继续？")) {
                                return;
                            }
                        }
                    }
                }
                if (thisCategoryId == "18") {//自由行
                    if (childPrice && auditPrice && gapPrice) {
                        if (childPrice - auditPrice > 0 && gapPrice - auditPrice > 0) {
                            if (!confirm("儿童价大于成人价，房差大于成人价！是否继续？")) {
                                return;
                            } else {
                                flag = false;//继续
                            }
                        }
                    }
                    if (flag) {
                        if (childPrice && auditPrice && childPrice - auditPrice > 0) {
                            if (!confirm("儿童价大于成人价！是否继续？")) {
                                return;
                            }
                        }
                        if (gapPrice && auditPrice && gapPrice - auditPrice > 0) {
                            if (!confirm("设置的房差大于成人价！是否继续？")) {
                                return;
                            }
                        }
                    }
                }
            }
        }


		validInitPrice();
		//前端交互设计价格校验
		if(!validateAddIsTrue.getIsValidate()){
			return ;
		}
		//判断使用行程
		var lineRouteId = $("select[name=lineRouteId]").val();
		if(lineRouteId == -1){
			alert("请选择适用行程");
			return ;
		}
		
			
		//构造Form提交数据
		$("#timePriceFormContent").empty();
		setSelectDate();
		//设置价格表单
	    setPriceFormData();
	    
	    //判断是否更新买断设置
	    toPreBudgeGoods();
	    
	    if("Y"== isBudgePrice)
	    {
	      //设置买断价格表单
	      setPreControlPriceFormData();
	      if(!isBindFlag){
	    		alert("请绑定预控项目");
				return ;
    		}else if(showMsg !=''){
    			alert(showMsg);
    			return;
    		}
	    }
	    if("N"== isBudgePrice){
	      return false;
	    }
	    
	    //设置签证材料最晚上传时间
		$("#upDocLastTimeContent").empty();	 
		var productType="${productType}";
	    var packageType="${packageType}";
	    var categoryCode="${categoryCode}";
	    var suppGoodsId_falg=$("#suppGoodsId_falg").attr("checked")
	    if(suppGoodsId_falg=="checked" && productType=="FOREIGNLINE" && packageType=="SUPPLIER" && (categoryCode=="category_route_group" || categoryCode=="category_route_freedom" || categoryCode=='category_route_customized')){
	    	var resFlag=setUpDocLastTime();
		}
		
		
	    //设置库存表单
	    setStockFormData();
	    //设置提前预定时间
	    setAheadBookTimeFormData();
	    //设置授权限制数据
	    setBookLimitTypeFormData();
	    //设置退改规则数据
	    setCancelStrategy();
	    //设置使用行程
	    setLineRouteIdData();
	    //判断销售价和结算价关系
		var res = validatePrice();
		if(res!=""){
			if(!confirm(res+"销售价低于结算价,是否继续")){
				return;
			}
		}
	    //设置预售
	    setPreSaleIdData();
	    $("input[type=checkbox][data=saleAbleAll]").each(function(){
	     	var value = $(this).is(':checked')?"Y":"N";
    		var adultObj = $("#adult");
    		var childObj = $("#child");
    		var gapObj = $("#gap");
    		if(adultObj ===""){
    			adultObj.val(value);
    		}
    		if(childObj ===""){
    			adultObj.val(value);
    		}
    		if(gapObj ===""){
    			adultObj.val(value);
    		}	
	    });
	    
	     $("input[type=checkbox][data=saleAble]").each(function(){
	        var id = $(this).attr("name");
	        var value = $(this).is(':checked')?"Y":"N";
        	if($("#"+id).val()===""){
        		$("#"+id).val(value);
        	}
	    });
	    
	    //设置产品ID
	    $("#timePriceFormContent").append('<input type="hidden" value="${prodProductId}" name="productId">');
        //获得最低毛利率
		if($(".adult_child:checked,.comb_hotel:checked").size()!=0){
            var result = getLowGoodsMargin("/vst_admin/goods/grossMargin/getLowerGrossMargin_Line.do",$("#timePriceForm").serialize());
            if(result!=null&&result.code=='WITH_LOWER'){
                lowPriceDialog = new xDialog("/vst_admin/goods/grossMargin/showAddLowPrice.do",{},{title:"低毛利上架原因",width:"600"});
            }else {
               submitTimePrice();
            }
		}else {
            submitTimePrice();
		}
	});
	
	//为禁售绑定事件
	$("input[type=checkbox][data=saleAble]").live('click',function(){
		var that = $(this);
		var claszz = that.attr("name");
		var goodsId = that.attr("goods");
		
		var goodsDiv = that.parents("div[goodsId]");
		var allBoxes = goodsDiv.find(":checkbox");
		var checkIndex = allBoxes.index(that);
		goodsDiv.find("input[type=text]").each(function(){
			var goods = $(this).attr("goods");
			/*
			if(checkIndex == 0){
				if(that.attr("checked")!='checked' ){
					if(goodsId == goods){
						$(this).removeAttr("disabled");
						goodsDiv.find("input[type=text][data_type=is_input]").each(function(){
							$(this).removeAttr("disabled");
						});
						goodsDiv.find("input[type=checkbox][data=saleAble]").not(allBoxes.first()).removeAttr("disabled");
						goodsDiv.find("input[type=checkbox][data=saleAbleAll]").first().removeAttr("disabled");	
						goodsDiv.find("input[type=checkbox][data=saleAble]").each(function(){
							var i = allBoxes.index($(this));
							if($(this).attr("checked")=='checked' ){
								goodsDiv.find("input[type=text][goods="+$(this).attr("goods")+"]").attr("disabled","disabled");
								goodsDiv.find("input[type=text][goods="+$(this).attr("goods")+"]").val("");
								goodsDiv.find("select").eq(i).attr("disabled","disabled");
							}else{
								goodsDiv.find("input[type=text][goods="+$(this).attr("goods")+"]").removeAttr("disabled");
								goodsDiv.find("select").eq(i).removeAttr("disabled");
								
							}
						});
						goodsDiv.find("select").eq(0).removeAttr("disabled");
					}					
				}else {
				
					if($(this).attr("goods")==goodsId){
						if(goodsId == goods){
							$(this).attr("disabled","disabled");
							$(this).val('');
							goodsDiv.find("input[type=text][data_type=is_input]").each(function(){
								$(this).attr("disabled","disabled");
								$(this).val("");
							});	
							goodsDiv.find("input[type=checkbox][data=saleAble]").not(allBoxes.first()).attr("disabled",'');
							goodsDiv.find("input[type=checkbox][data=saleAbleAll]").first().attr("disabled",'');
							goodsDiv.find("select").attr("disabled","disabled");
							
						}
					}
				}
				
			}else{
			*/
				if(that.attr("checked")!='checked' ){
					if(goodsId == goods){
						$(this).removeAttr("disabled");
						goodsDiv.find("select").eq(checkIndex).removeAttr("disabled");
					}					
				}else {
					if($(this).attr("goods")==goodsId){
						if(goodsId == goods){
							$(this).attr("disabled","disabled");
							//如果是酒店套餐，点击禁售价格不清空
							<#if categoryCode!='category_route_hotelcomb'>
								$(this).val('');
							</#if>	
							goodsDiv.find("select").eq(checkIndex).attr("disabled","disabled");							
						}
					}
				}
			
			/*}*/
			
		});
	});
	
	//全部禁售绑定事件
	$("input[type=checkbox][data=saleAbleAll]").live('click',function(){
		var that = $(this);
		var claszz = that.attr("name");
		var goodsId = that.attr("goods");
		var goodsDiv = that.parents("div[goodsId]");
		
		if(that.attr("checked")!="checked"){
			$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=text][data_type=is_input]").each(function(){
				$(this).removeAttr("disabled");
				goodsDiv.find("select").removeAttr("disabled");
				goodsDiv.find(":checkbox").removeAttr("checked");
				
			});
		}else{
			$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=text][data_type=is_input]").each(function(){
				$(this).attr("disabled","disabled");
				$(this).val("");
				goodsDiv.find("select").attr("disabled","disabled");
			});		
		}			
	});
		
	//取消按钮关闭弹窗
	$('#timePriceCancelButton').live('click',function(){
		window.parent.bacthButtonDialog.close();
	});
	

	
	//日期选择方式切换清空数据
	$("input[type=radio][name=dateType]").live("click",function(){
		var t = $(this).val();
		if(t == "selectDate"){
			$("input[type=checkbox][name=weekDayAll]").attr("checked",false);
			$("input[type=checkbox][name=weekDay]").attr("checked",false);
			$("#d4321").val("");
			$("#d4322").val("");
		}else if(t == "selectTime"){
			$(".JS_select_date td.calSelected[date-map]").removeClass("calSelected");
			$(".JS_select_date_hidden option").remove();
		}
		clearUpDocLastTime(t);
	})	
	
	//库存选择按钮绑定清空库存时间	
	function clearStock(){
		var that = $(this);
		var stockRadiosFather = that.parents(".JS_radio_switch_group");
		var nowRadios = stockRadiosFather.find(":radio[data=stockType]");
		var nowStocks = stockRadiosFather.find("input[type=text]");
		var nowOrder = nowRadios.index(that);
		if(nowOrder == 0){
			inputs.each(function(){
				$(this).val("");
			})
		}
		if(nowOrder == 1){
			inputs.eq(2).val();
		}
		if(nowOrder == 2){
			inputs.eq(1).val();
		}
	}
	
	
	
	//设置选择日期数据
	function setSelectDate(){
		var selectCalendar = $('input[name=dateType]:checked').val();
		$("#timePriceFormContent").append('<input type="hidden" name="selectCalendar" value="'+selectCalendar+'">');
		if(selectCalendar=='selectDate'){
			$("#optionDate option").each(function(){
			
				$("#timePriceFormContent").append('<input type="hidden" name="selectDates" value="'+$(this).val()+'">');
			});
		}			
	}
	
	//设置价格表单数据
	function setPriceFormData(){
		var t = 0 ; 
		$("#price_set").find("div[data='priceDiv']").each(function(i){
	    	var that = $(this);
	    	if($.trim(that.html())!=''){
	    		//创建商品Id
		    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].suppGoodsId" value="'+that.attr("goodsId")+'">');
		    	var onsaleFlag = 'N'; 
		    	that.find("input[data_type=is_input]").each(function(){
		    		var clone = $(this).clone();
		    		var name = clone.attr("data");
		    		var inputName = "timePriceList["+t+"]."+name
		    		var inputValue=  clone.val(); 
		    		if(inputValue!=""){
		    			var clonevalue = clone.val();
			    		var start = clonevalue.lastIndexOf(".");
			    		var len = clonevalue.length-1;
			    		var decimallen = len - start; 
			    		//parseInt精度有问题0.1变0.099
			    		if(clonevalue.indexOf(".") == -1){
			    			inputValue = parseInt(clone.val()*100,0);
			    		}else if(decimallen == 1){
			    			inputValue = clone.val().replace(".","")+"0";
			    		}else if(decimallen == 2){
			    			inputValue = clone.val().replace(".","");
			    		}
			    		inputValue = parseInt(inputValue);
			    		clone.removeAttr('disabled');
		    			$("#timePriceFormContent").append('<input type="hidden" name="'+inputName+'" value="'+inputValue+'">');
		    			onsaleFlag = 'Y';
		    		}
		    	});
		    	//酒店套餐的禁售要根据禁售标志判断
		    	<#if categoryCode=='category_route_hotelcomb'>
					that.find("input[data=saleAble]").each(function(){
						if($(this).attr("checked")=='checked'){
							onsaleFlag = 'N';
						}
					});
				</#if>
		    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].onsaleFlag" value="'+onsaleFlag+'">');
		    	t++;
	    	}	
	    });
	}
	
	
	//预控买断价格表单数据设置
	function setPreControlPriceFormData(){	
	 var i = 0 ; 
		$("#price_set_pre").find("div[data='priceDiv']").each(function(){
	    	var that = $(this);
	    	var goodsId = that.attr("goodsId");
			
	    	if($.trim(that.html())!=''){
	    	   if(that.attr('style')){
	    	   	   if(that.attr('style').indexOf('display: none')>=0){
	    		    return true;
	    	      }
	    	   }

	    		//创建商品Id
		    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].suppGoodsId_pre" value="'+that.attr("goodsId")+'">');
		    	var isPreControl = that.find("input[type=radio][name='isPreControlPrice'+goodsId][checked]").val();
		    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].isPreControl"  value="'+isPreControl+'">');
		    	
		    	var preSaleFlagRadios = $(":radio[name=useBudgePrice"+goodsId+"]");
				var tmp = preSaleFlagRadios.eq(0);
				var preSaleFlag = "checked".indexOf(tmp.attr("checked"))>=0 ? "Y":"N";
		    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].preSaleFlag"  value="'+preSaleFlag+'">');
		    	
		    	var supplierId = $("#bindControlProject",$(".bindControlProject"+goodsId)).attr("suppid");
		    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].supplierId"  value="'+supplierId+'">');
		    	var resPrecontrolIds = $("#resPrecontrolIds"+goodsId).val();
		    	
		    	if(isPreControl == 'Y' &&  resPrecontrolIds == ''){
		    		showMsg = '';
		    		isBindFlag = false;
		    		return;
		    	}else if(isPreControl == 'N'){
		    		$.ajax({
						url:'/vst_admin/lineMultiroute/goods/timePrice/showControlProjectData.do',
						data:{
							suppId:supplierId,
							goodsId:goodsId
						},
						type:"GET",
						async:false,
						dataType:"json",
						success:function(result){
							if(result!=null && result.length > 0){
								showMsg = '商品已绑定预控项目，如修改买断商品为不可预控，商品需在预控项目中进行解绑后，才可设置为不可预控';
							}
						}
					 });
					 isBindFlag = true;
		    	}else{
		    		showMsg = '';
		    		isBindFlag = true;
		    	}
		    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].resPrecontrolIds"  value="'+resPrecontrolIds+'">');
		    	
		    	
		    	that.find("input[data_type=is_input]").each(function(){
		    		var clone = $(this).clone();
		    		var name = clone.attr("data");
		    		var inputName = "timePriceList["+i+"]."+name
		    		var inputValue=  clone.val(); 
		    		if(inputValue!=""){
		    			var clonevalue = clone.val();
			    		var start = clonevalue.lastIndexOf(".");
			    		var len = clonevalue.length-1;
			    		var decimallen = len - start; 
			    		//parseInt精度有问题0.1变0.099
			    		if(clonevalue.indexOf(".") == -1){
			    			inputValue = parseInt(clone.val()*100,0);
			    		}else if(decimallen == 1){
			    			inputValue = clone.val().replace(".","")+"0";
			    		}else if(decimallen == 2){
			    			inputValue = clone.val().replace(".","");
			    		}
			    		inputValue = parseInt(inputValue);
			    		clone.removeAttr('disabled');
		    			$("#timePriceFormContent").append('<input type="hidden" name="'+inputName+'" value="'+inputValue+'">');
		    		}
		    	});
		    	i++;
	    	}	
	    });
	}
	//设置库存表单数据
	function setStockFormData(){
		var t = 0 ; 
		$("#stock_set").find("div[data='stockDiv']").each(function(i){
	    	var that = $(this);
	    	if($.trim(that.html())!=''){
	    		that.find("input[type=radio][data=stockType]").each(function(){
		    		if($(this).attr("checked")=='checked'){
		    			var value = $(this).val();
		    			var clone = $(this).clone();
	    				clone.attr("name","timePriceList["+t+"].stockType");
	    				$("#timePriceFormContent").append(clone);
		    			//如果是现询-已知库存	或者是切位库存
		    			if(value=='INQUIRE_WITH_STOCK' || value=='CONTROL'){
		    				var stockInput = $(this).parent().parent().parent().find("div").eq(1).find("input[type=text]");
		    				//获得库存input
		    				var clone1 = stockInput.clone();
		    				//获得库存的类型
		    				clone1.attr("name","timePriceList["+t+"].stock");
		    				clone1.val(stockInput.val());
	    					$("#timePriceFormContent").append(clone1);
	    					
	    					var obj2 = that.find("input[data=oversellFlag][type=radio]:checked");
	    					//var obj2 = $(this).parent().parent().find("div").eq(1).find("input[type=radio]:checked");
	    					var clone2 = obj2.clone();
		    				clone2.attr("name","timePriceList["+t+"].oversellFlag");
		    				clone2.val(obj2.val());
		    				clone2.removeAttr('disabled');
	    					$("#timePriceFormContent").append(clone2);
		    			}
		    			t++;
		    		}
	    		});
	    	}	
	    });
	}
	
	//绑定预控项目
	var bindControlProjectDialog;
	function bindControlProject(obj){
		var goodsId = obj.attr('goodsid');
		var suppId = obj.attr('suppid');
		
		bindControlProjectDialog = new xDialog("/vst_admin/lineMultiroute/goods/timePrice/showControlProject.do?goodsId="+goodsId+"&suppId="+suppId,{}, {title:"绑定预控项目",width:750,height:400,iframe:true})
	}
	
	//同步 成人/儿童/房差 中设置价格及状态 到买断价
	function syncBudgePrice(obj){
		var goodsId = obj.attr('goodsId');
	    var preDivClass = 'isPreControlDiv'+goodsId;
	
		var adultSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='auditSettlementPrice_pre']");//成人结算
		var adultPrice_pre = $("."+preDivClass).find("input[type=text][name='auditPrice_pre']");//成人销售
		var adultReadOnlyNum_pre = $("."+preDivClass).find("input[type=text][name='adultReadOnlyNum_pre']");//自定义数值
		
		if(adultSettlementPrice_pre.attr("disabled") != "disabled"){
			adultSettlementPrice_pre.val($("input[type=text][name^='auditSettlementPrice'][data='auditSettlementPrice'][goods='adult"+goodsId+"']").val());
			var adultPriceRule = $("div[data='priceDiv'][goodsid="+goodsId+"]").find("select[name='adultPriceRule"+goodsId+"']").val();
			
			if(adultPriceRule != undefined && adultPriceRule != 'custom'){
				$("."+preDivClass).find("select[name='adultPriceRule_pre']").children().each(function(){
					if($(this).val() == adultPriceRule){
						$(this).attr("selected","selected");
					}
				});
				
				adultPrice_pre.attr("readonly","readonly");
				adultReadOnlyNum_pre.removeAttr("readonly");
				
				if(adultPriceRule == 'percent'){
					adultReadOnlyNum_pre.next("span.JS_price_percent").css("display","inline");
				}else{
					adultReadOnlyNum_pre.next("span.JS_price_percent").css("display","none");
				}
				
				//销售价获取规则值
				adultReadOnlyNum_pre.val($("input[type='text'][name='adultReadOnlyNum"+goodsId+"']").val());
			}
			adultPrice_pre.val($("input[type='text'][data='auditPrice'][name^='auditPrice'][goods='adult"+goodsId+"']").val());
		}
		
		var goodPriceType = $("input[type='checkbox'][name='suppGoodsId'][value='"+goodsId+"']").attr("data_price_type");
		
		if(goodPriceType=="MULTIPLE_PRICE"){
			var childSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='childSettlementPrice_pre']");//儿童结算
		    var childPrice_pre = $("."+preDivClass).find("input[type=text][name='childPrice_pre']");//儿童销售
		    var childReadOnlyNum_pre = $("."+preDivClass).find("input[type=text][name='childReadOnlyNum_pre']");//自定义数值
		    
			if(childSettlementPrice_pre.attr("disabled") != "disabled"){
				childSettlementPrice_pre.val($("input[type=text][name^='childSettlementPrice'][data='childSettlementPrice'][goods='child"+goodsId+"']").val());
				var childPriceRule = $("div[data='priceDiv'][goodsid="+goodsId+"]").find("select[name='childPriceRule"+goodsId+"']").val();
				
				if(childPriceRule != undefined && childPriceRule != 'custom'){
					$("."+preDivClass).find("select[name='childPriceRule_pre']").children().each(function(){
						if($(this).val() == childPriceRule){
							$(this).attr("selected","selected");
						}
					});
					
					childPrice_pre.attr("readonly","readonly");
					childReadOnlyNum_pre.removeAttr("readonly");
					
					if(childPriceRule == 'percent'){
						childReadOnlyNum_pre.next("span.JS_price_percent").css("display","inline");
					}else{
						childReadOnlyNum_pre.next("span.JS_price_percent").css("display","none");
					}
				
					//销售价获取规则值
					childReadOnlyNum_pre.val($("input[type='text'][name='childReadOnlyNum"+goodsId+"']").val());
				}
				childPrice_pre.val($("input[type='text'][data='childPrice'][name^='childPrice'][goods='child"+goodsId+"']").val());
			}
		}
	
		
		
			    	
	}
	
	//设置提前预定时间表单数据
	function setAheadBookTimeFormData(){
		var t = 0 ; 
		$("#aheadBookTime_set").find("div[data='timeDiv_date']").each(function(i){
		    var that = $(this);
		    if($.trim(that.html())!=''){
			    //把提前预定时间转换为分钟数	
				var day = parseInt(that.find("select[name=aheadBookTime_day]").val());
				var hour = parseInt(that.find("select[name=aheadBookTime_hour]").val());
				var minute = parseInt(that.find("select[name=aheadBookTime_minute]").val());
			    $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].aheadBookTime" value="'+(day*24*60-hour*60-minute)+'">');
			    t++;	
			}    
	    });
	}
	
	//设置授权限制数据
	function setBookLimitTypeFormData(){
	var t = 0 ; 
		$("#aheadBookTime_set").find("div[data='timeDiv_limit']").each(function(i){
			var that = $(this);
			
			if($.trim(that.html())!=''){
				
		    	//把提前预定时间转换为分钟数	
				var bookLimitType = that.find("select[name=bookLimitType]").val();
		   		 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].bookLimitType" value="'+bookLimitType+'">');	
		   		 t++;
			}
		    
	    });
	}	
	
	//设置退改规则数据
	function setCancelStrategy(){
		var cancelStrategy = $('input[data=selectCancelStrategy]:checked').val();		
		$('#cancelStrategy').val(cancelStrategy);
	}
	
	//设置适用行程
	function setLineRouteIdData(){
		var lineRouteId = $("select[name=lineRouteId]").val();
		$("#timePriceFormContent").append('<input type="hidden" name="lineRouteId" value="'+lineRouteId+'">');		
	}
	//
	//设置预售
	function setPreSaleIdData(){
	      var t = 0 ; 
	   $('#timePriceFormInput').siblings("div.row").find("input[type='checkbox']").each(function(i){
	    var that = $(this);
	     var PreSale=that.parents('div.row').siblings('#timePriceFormInput').find('#Set_PreSale').find('div[data=preSaleDiv][goodsId='+$(this).attr('value')+']');
	     if($.trim(PreSale.html())!=''){
			     var bringPreSale = PreSale.find("[type=radio]:checked").val();
		   		 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].bringPreSale" value="'+bringPreSale+'">');
		   		 var auditShowPreSale_pre = PreSale.find("input[name='auditShowPreSale_pre']").val()*100;
		   		 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].auditShowPreSale_pre" value="'+auditShowPreSale_pre+'">');
		   		var childShowPreSale_pre = PreSale.find("input[name='childShowPreSale_pre']").val()*100;
		   		 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].childShowPreSale_pre" value="'+childShowPreSale_pre+'">');
		   		 if(PreSale.find("input[name='auditShowPreSale_pre']").prop("disabled")){
		   		  $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].auditIsBanSell" value="Y">');
		   		 }else{
		   		  $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].auditIsBanSell" value="N">');
		   		 }
		   		 if(PreSale.find("input[name='childShowPreSale_pre']").prop("disabled")){
		   		  $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].childIsBanSell" value="Y">');
		   		 }else{
		   		  $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].childIsBanSell" value="N">');
		   		 }
		   		t++;
		  }
	   });
	}
	var lowPriceDialog;
	 //低毛利率
    function submitLowPrice(){
    	
        $.ajax({
            url : '/vst_admin/goods/grossMargin/saveGrossMarginLogs.do',
            method: 'POST',
            data : $("#lowPriceForm,#timePriceForm").serialize(),
            async : true,
            success : function(result){
                lowPriceDialog.close();
            }
        })
    }
	
	function submitTimePrice(){
	    var loading = top.pandora.loading("正在努力保存中...");
		$.ajax({
				url : "/vst_admin/lineMultiroute/goods/timePrice/editGoodsTimePrice.do",
				data :　$("#timePriceForm").serialize(),
				dataType:'JSON',
			  	type: "POST",
				success : function(result){
					loading.close();
					if(result.code == 'success'){
						resetInitForm();
						window.location.reload();
						var infoMsg = '';
						if(result.attributes){
							if(result.attributes.infoMsg){
								infoMsg = result.attributes.infoMsg;
							}
						}
						newAlert("保存成功!"+infoMsg);
					}else{
						newAlert('保存失败!');
					}
				},
				error : function(){
				      newAlert('服务器错误');
		             loading.close();
				}
		});
	}

     //保存清空表单数据
    function resetInitForm(){
    	$("input[type=checkbox][name=suppGoodsId]").each(function(){				
			$(this).attr("checked",false);
			var goodsId = $(this).val();
			deleteTemplate(goodsId);
			globalIndex = 0;
			additionIndex = 0; 
		})
		$(".JS_select_date td.calSelected[date-map]").removeClass("calSelected");
		$(".JS_select_date_hidden option").remove();
		$("input[type=checkbox][name=weekDayAll]").attr("checked",false);
		$("input[type=checkbox][name=weekDay]").attr("checked",false);
		$("input[type=radio][value=selectDate]").attr("checked",true);
		$("input[type=radio][value=MANUALCHANGE]").attr("checked",true);
		$("#d4321").val("");
		$("#d4322").val("");
		$("#multiple_preSale_template_new_preSale").find("input[name=bringPreSale"+goodsId+"]").attr("checked",false);
		$("div.isPreSaleDiv"+goodsId).find("input[name='auditShowPreSale_pre']").val("");
		$("div.isPreSaleDiv"+goodsId).find("input[name='childShowPreSale_pre']").val("");
		$("select[name=lineRouteId]").val(-1);
    }
    //弹框效果    
    function newAlert(content){
    	backstage.alert({
    		content: content
		});
    }
	
	//验证销售价和结算价关系
	function validatePrice(){
		var result = "";
		var index = 0;
		//判断成人儿童方差find("div[data='timeDiv_date']")
		$("#price_set").find("div[divTag='adult_child_diff']").each(function(i){
			
            var that = $(this);
            if(that.html()!='undefined' && $.trim(that.html())!=''){
            	 var auditSettlementPriceVal = that.find("input[disabled!=disabled][data=auditSettlementPrice]").val();
				var auditPriceVal = that.find("input[disabled!=disabled][data=auditPrice]").val();
				if(auditSettlementPriceVal!=null && (parseFloat(auditSettlementPriceVal) > parseFloat(auditPriceVal))){
	                result = "成人儿童房差 ";
					return false;
				}
	
	            var childSettlementPriceVal = that.find("input[disabled!=disabled][data=childSettlementPrice]").val();
	            var childPriceVal = that.find("input[disabled!=disabled][data=childPrice]").val();
	            if(childSettlementPriceVal!=null && (parseFloat(childSettlementPriceVal) > parseFloat(childPriceVal))){
	                result = "成人儿童房差 ";
	                return false;
	            }
	
	            var gapSettlementPriceVal = that.find("input[disabled!=disabled][data=grapSettlementPrice]").val();
	            var gapPriceVal = that.find("input[disabled!=disabled][data=gapPrice]").val();
	            if(gapSettlementPriceVal!=null && (parseFloat(gapSettlementPriceVal) > parseFloat(gapPriceVal))){
	                result = "成人儿童房差 ";
	                return false;
	            }
            }	
        });
        
        $("#price_set").find("div[divTag='combo_dinner']").each(function(i){
        	//酒店套餐
        	 var that = $(this);

            if(that.html()!='undefined' && $.trim(that.html())!=''){
	            var auditSettlementPriceVal_hotel = that.find("input[data=auditSettlementPrice]").val();
	            var auditPriceVal_hotel = that.find("input[data=auditPrice]").val();
	            if(auditSettlementPriceVal_hotel!=null && (parseFloat(auditSettlementPriceVal_hotel) > parseFloat(auditPriceVal_hotel))){
	                result = "套餐 ";
	                return false;
	            }
        	}
        })
		//判断附加
        $("#price_set").find("div[divTag='addition']").each(function(i){
            var that = $(this);
            if(that.html()!='undefined' && $.trim(that.html())!=''){
            
	            var auditSettlementPriceVal = that.find("input[data=auditSettlementPrice]").val();
	            var auditPriceVal = that.find("input[data=auditPrice]").val();
	            if(parseFloat(auditSettlementPriceVal) > parseFloat(auditPriceVal)){
	                result = result + "附加 ";
	                return false;
	            }
            }
        });
		//判断升级
		 $("#price_set").find("div[divTag='upgrad']").each(function(i){
            var that = $(this);
            if(that.html()!='undefined' && $.trim(that.html())!=''){
	            var auditSettlementPriceVal = that.find("input[data=auditSettlementPrice]").val();
	            var auditPriceVal = that.find("input[data=auditPrice]").val();
	            if(parseFloat(auditSettlementPriceVal) > parseFloat(auditPriceVal)){
	                result = result + "升级 ";
	                return false;
	            }
            }
        });
		//判断可换
        $("#price_set").find("div[divTag='changed_hotel']").each(function(i){
            var that = $(this);
            if(that.html()!='undefined' && $.trim(that.html())!='' ){
	            var auditSettlementPriceVal = that.find("input[data=auditSettlementPrice]").val();
	            var auditPriceVal = that.find("input[data=auditPrice]").val();
	            if(parseFloat(auditSettlementPriceVal) > parseFloat(auditPriceVal)){
	                result = result + "可换酒店 ";
	                return false;
	            }
            }
        });
		return result;
	}
	
	//动态给第一个附加项价格模块显示附加标示	
	function showAdditionTag(){
		var tag = true;
		$("#price_set").find("div[divTag='addition']").each(function(){
			var that = $(this);
			if(that.html()!='undefined' && $.trim(that.html())!=''){
				if(tag){
					that.find("div[data=additionTag]").eq(0).html("附加:");
				}else{
					that.find("div[data=additionTag]").eq(0).html("");
				}
				tag = false;
			}
			
		
		})
	}
	
	function showCommonTag(divTag,tagName){
		var tag = true;
		$("#timePriceFormInput").find("div[divTag="+divTag+"]").each(function(){
			var that = $(this);
			if(that.html()!='undefined' && $.trim(that.html())!='' ){
				if(tag){
					that.find("div[data=additionTag]").eq(0).html(tagName+":");
				}else{
					that.find("div[data=additionTag]").eq(0).html("");
				}
				tag = false;
			}
			
		
		})
	
	}
	
	//设置需要校验的表单元素
	function setValidElementForm(){
		var nullMsg = "";

		//库存校验
   		$("div[data='stockDiv']").each(function(i){
	    	var that = $(this);
	    	if($.trim(that.html())!=''){
	    		var hasCheck = that.find('input[data="stockType"]:checked').size();
	    		if(hasCheck <=0){
	    			nullMsg = "请选择库存类型";
	    			return false;
	    		}
	    		
	    		that.find("input[type=radio][data=stockType]").each(function(){
		    		if($(this).attr("checked")=='checked'){
		    			var value = $(this).val();
		    			//如果是现询-已知库存	或者是切位库存
		    			if(value=='INQUIRE_WITH_STOCK' || value=='CONTROL'){
		    				var object = $(this).parent().parent().parent().find("div").eq(1).find("input[type=text]").eq(0);
		    				var oV = object.val();
		    				if(oV=="undefined" || oV==null || $.trim(oV)==""){
		    					nullMsg =  "库存不能为空！";
		    					return false;
		    				}			
		    			}
		    		}
	    		});
	    		if(nullMsg!=""){
					return false;
				}
	    	}	
	    }); 
	    
	     if(nullMsg!=""){
			return nullMsg;
		}
		//价格校验
		$("div[data='priceDiv']").each(function(){
	   		var that = $(this);
	   		var size = that.find("input[type=text][data_type=is_input][disabled!=disabled][display!=none]").size();
	   					
			that.find("input[type=text][data_type=is_input][disabled!=disabled][display!=none]").each(function(){
				var oV = $(this).val();
				if(oV=="undefined" || oV==null || $.trim(oV)==""){
		    		nullMsg =  "价格不能为空！";
		    		return false;
		    	}
				/*
				if($(this).attr("notnumber")!="Y"){
					$(this).rules("add",{required: true, number : true,isNum:true , min : 0,messages : {min:'价格必须大于等于0',isNum:'价格格式不正确(填至多2位小数正数)'}});
    			}
				*/
			});
			if(nullMsg!=""){
				return false;
			}
		
		})
		
		 if(nullMsg!=""){
			return nullMsg;
		}
		

	    //提前预定时间校验
	    $("#aheadBookTime_set").find("div[data='timeDiv_date']").each(function(i){
		    var that = $(this);
		    if($.trim(that.html())!=''){
			    //把提前预定时间转换为分钟数	
				var day = parseInt(that.find("select[name=aheadBookTime_day]").val());
				if(day == -1){
					nullMsg = "提前预定时间天数不能为空";
					return false;
				}
				var hour = parseInt(that.find("select[name=aheadBookTime_hour]").val());
				if(hour == -1){
					nullMsg = "提前预定时间小时不能为空";
					return false;
				}
				var minute = parseInt(that.find("select[name=aheadBookTime_minute]").val());
				if(minute == -1){
					nullMsg = "提前预定时间分钟不能为空";
					return false;
				}
			    
			}    
	    });
	    
	    if(nullMsg!=""){
			return nullMsg;
		}
		
	    $("#aheadBookTime_set").find("div[data='timeDiv_limit']").each(function(i){
		    var that = $(this);
		    if($.trim(that.html())!=''){
			    
				var bookLimitType = that.find("select[name=bookLimitType]").val();
				if(bookLimitType == ""){
					nullMsg = "预付预授权限制不能为空";
					return false ; 
				}
			    
			}    
	    });
	    	
	    return nullMsg;					
	}
	
	//删除模板
	function deleteTemplate(goodsId){
		$("div[goodsid="+goodsId+"]").empty();
		$("div[goodsid="+goodsId+"]").hide();
	}	
	
	//设置成人儿童模板
	function setAdultChildTemplate(goodsId,priceTemplate,stockTemplate,aheadBookTimeTemplate,priceTemplate_pre,preSaleTemplate){
		//设置价格模板
		var priceTemplates = $("#price_set").find("div[goodsId="+goodsId+"]");
		priceTemplates.append(priceTemplate);
		priceTemplates.show();

		//设置库存模板
		var stockTemplates = $("#stock_set").find("div[goodsId="+goodsId+"]");
		stockTemplates.append(stockTemplate);
		stockTemplates.show();
		
		//设置提前预定时间模板
		var aheadBookTimeTemplate_date = aheadBookTimeTemplate.split("---0ahead0---")[0];
		var aheadBookTimeTemplate_limit = aheadBookTimeTemplate.split("---0ahead0---")[1];
		var timeDiv_dateTemplates = $("#aheadBookTime_set").find("div[goodsId="+goodsId+"][data='timeDiv_date']");
		timeDiv_dateTemplates.append(aheadBookTimeTemplate_date);
		var timeDiv_limitTemplates = $("#aheadBookTime_set").find("div[goodsId="+goodsId+"][data='timeDiv_limit']");
		timeDiv_limitTemplates.append(aheadBookTimeTemplate_limit);
		timeDiv_dateTemplates.show();
		timeDiv_limitTemplates.show();
		
		//买断价格设置
		var priceTemplates_pres = $("#price_set_pre").find("div[goodsId="+goodsId+"]");
		if(priceTemplates_pres.length>0){
		 priceTemplates_pres.append(priceTemplate_pre);
		 priceTemplates_pres.show();
		 showPreDom($(":radio[name=isPreControlPrice"+goodsId+"]").eq(1));
		}
		
		//预售价格设置
		 var preSaleTemp= $("#Set_PreSale").find("div[goodsId='"+goodsId+"']");
	     preSaleTemp.append(preSaleTemplate);
		 preSaleTemp.show();	
	}
	
	function validWeekHasDate(a,b,weeks){
		var dateA = new Date(a.split("-"));
		var dateB = new Date(b.split("-"));
		var days =  parseInt(Math.abs(dateB.getTime() - dateA.getTime()) / 1000 / 60 / 60 /24);		
		if(days<6){
			var hasDate = false;
			if(weeks.indexOf((dateA.getDay()+1).toString()) !=-1){
					hasDate = true;
					return true;
			}
			if(!hasDate){
				for(var i = 1;i<=days;i++){
					var week = dateA.getDate()+1;
					dateA.setDate(week);
					if(weeks.indexOf((dateA.getDay()+1).toString()) !=-1){
						hasDate = true;
						return true;
					}
					
				}
				
			}
			if(hasDate){
				return true;
			}
		}else{
			return true;
		}
			
	
		return false;
	}
	

	//是否显示买断价格
	function showPreDom(obj){
	  var goodsId = obj.attr('goodsId');
	  var preDivClass = 'isPreControlDiv'+goodsId;
	  var controlProjectDivClass = 'bindControlProject'+goodsId;
	   var auditSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='auditSettlementPrice_pre']");
	   var childSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='childSettlementPrice_pre']");
	   var auditPrice_pre = $("."+preDivClass).find("input[type=text][name='auditPrice_pre']");
	   var childPrice_pre = $("."+preDivClass).find("input[type=text][name='childPrice_pre']");
	   var goodsArray=''+goodsId;

		if(obj.val()=='Y')
		{
		    $("."+preDivClass).show(); 
		    $("."+controlProjectDivClass).show(); 
		    
		    var resPrecontrolIds = $("#resPrecontrolIds"+goodsId).val();
		    if(resPrecontrolIds == ""){
		    	var supplierId = $(".bindControlProject"+goodsId+ " #bindControlProject").attr("suppid");
		    	$.ajax({
					url:'/vst_admin/lineMultiroute/goods/timePrice/showControlProjectData.do',
					data:{
						suppId:supplierId,
						goodsId:goodsId
					},
					type:"GET",
					async:false,
					dataType:"json",
					success:function(result){
						if(result!=null){
							//赋值买断预控项目
							var resPrecontrolPolicies = result;
						   	var resPrecontrolIdArray = new Array();
						   	var resPrecontrolNameArray = new Array();
							for(var i=0;i<resPrecontrolPolicies.length;i++){
								var resPrecontrolProject = resPrecontrolPolicies[i];
								resPrecontrolIdArray.push(resPrecontrolProject.id);
	       						resPrecontrolNameArray.push(resPrecontrolProject.name);
							}
							var resPrecontrolIdString=resPrecontrolIdArray.join(',');
		   					var resPrecontrolNameString=resPrecontrolNameArray.join(',');
		   					
		   					$("#resPrecontrolIds"+goodsId).val(resPrecontrolIdString);
						    $("#selectPreControlName",$(".bindControlProject"+goodsId)).text(resPrecontrolNameString);
						    
						    $("#selectPreControlName",$(".bindControlProject"+goodsId)).show();
	    					$("#bindControlProject",$(".bindControlProject"+goodsId)).hide();
						}
					}
				 });
		    }
		    
		    auditSettlementPrice_pre.removeAttr("disabled");
			childSettlementPrice_pre.removeAttr("disabled");			
			auditPrice_pre.removeAttr("disabled");		
			childPrice_pre.removeAttr("disabled");
			$("#price_set_pre").find("div[data='priceDiv'][goodsId="+goodsId+"]").addClass('isPreMod');
			showPreControl($(":radio[name=isPreControlPrice"+goodsId+"]").eq(1));
			
			
			$.ajax({
				url:'/vst_admin/lineMultiroute/goods/timePrice/isPreBudgeGoods.do',
				data:{
					goodsArrays:goodsArray
				},
				type:"GET",
				async:false,
				dataType:"json",
				success:function(result){
					if(result.data!='Y'){
						alert("该商品为非买断商品，是否将其改为买断商品？如果不是，请将是否可预控选择：否");
					}
				}
				
			 });
		}else
		{
		  $("."+preDivClass).hide();
		  $("."+controlProjectDivClass).hide();
		  if(checkBindPrecontrol == "Y"){
		  	$("#resPrecontrolIds"+goodsId).val('');
		    $("#selectPreControlName",$(".bindControlProject"+goodsId)).text('');
	  		$("#selectPreControlName",$(".bindControlProject"+goodsId)).hide();
			$("#bindControlProject",$(".bindControlProject"+goodsId)).show();
		  }
		  
		  auditSettlementPrice_pre.attr("disabled","disabled");			
		  childSettlementPrice_pre.attr("disabled","disabled");
		  auditPrice_pre.attr("disabled","disabled");			
		  childPrice_pre.attr("disabled","disabled");
		  $("#price_set_pre").find("div[data='priceDiv'][goodsId="+goodsId+"]").removeClass('isPreMod');
		  //当商品禁止预控的时候，买断价，也要设置为不启用
			var preSaleFlagRadios = $(":radio[name=useBudgePrice"+goodsId+"]");
			preSaleFlagRadios.eq(0).removeAttr("checked");
			preSaleFlagRadios.eq(1).attr("checked","checked");
				$.ajax({
				url:'/vst_admin/lineMultiroute/goods/timePrice/isPreBudgeGoods.do',
				data:{
					goodsArrays:goodsArray
				},
				type:"GET",
				async:false,
				dataType:"json",
				success:function(result){
				if(result.data!='N'){
				alert("该商品为买断商品，是否将其改为非买断商品？如果不是，请将是否可预控选择：是");
				}
				}
				
			 });
		}
	
	}
	
	function showPreControl(obj){
		var goodsId = obj.attr('goodsId');
	  	var preDivClass = 'isPreControlDiv'+goodsId;
	   var auditSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='auditSettlementPrice_pre']");
	   var childSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='childSettlementPrice_pre']");
	   var auditPrice_pre = $("."+preDivClass).find("input[type=text][name='auditPrice_pre']");
	   var childPrice_pre = $("."+preDivClass).find("input[type=text][name='childPrice_pre']");
		if(obj.val()=='Y')
		{
		    $("."+preDivClass).show(); 
		    if($("#adultjinshou").is(":checked")||$("#adult1").is(":checked")||$("#adult2").is(":checked")){

		    }else{
		    auditSettlementPrice_pre.removeAttr("disabled").val("");
		    auditPrice_pre.removeAttr("disabled").val("");	
		    }
		    if($("#jinshou").is(":checked")||$("#child1").is(":checked")){

			}else{
			childSettlementPrice_pre.removeAttr("disabled").val("");			
			childPrice_pre.removeAttr("disabled").val("");
			}
			$("#price_set_pre").find("div[data='priceDiv'][goodsId="+goodsId+"]").addClass('isPreMod');
			
			//跟团游、周边游露出价格同步按钮
			<#if categoryCode=='category_route_group' || categoryCode=='category_route_local'>
				$("#syncPrice").css("display","inline-block");
			</#if>
		
		}else
		{
		  $("."+preDivClass).hide();
		  auditSettlementPrice_pre.attr("disabled","disabled");			
		  childSettlementPrice_pre.attr("disabled","disabled");
		  auditPrice_pre.attr("disabled","disabled");			
		  childPrice_pre.attr("disabled","disabled");
		  $("#price_set_pre").find("div[data='priceDiv'][goodsId="+goodsId+"]").removeClass('isPreMod');

		  $("div[div=useBudgePriceDiv"+goodsId+"]").show();
		  //跟团游、周边游隐藏价格同步按钮
		  <#if categoryCode=='category_route_group' || categoryCode=='category_route_local'>
		  	$("#syncPrice").css("display","none");
		  </#if>
		}
	}
	
		//设置预控隐藏
	function forbidPreContorl(obj,num,type){	  
		 
	  if(type == 'forbidSaleSingle')
	  {
	      var goodsId =  obj.attr('goodsid');
		  if(obj.attr("checked")!='checked'){
			  $("#price_set_pre").find("div[class*="+type+"][data='priceDiv'][goodsid="+goodsId+"]").show();
			  $("#price_set_pre").find("div[class*="+type+"][data='priceDiv'][goodsid="+goodsId+"]").find("input[type=text]").removeAttr("disabled");
			  $("#price_set_pre").find("div[class*="+type+"][data='priceDiv'][goodsid="+goodsId+"]").find("input[type=radio]").removeAttr("disabled");
		  }else{
			  $("#price_set_pre").find("div[class*="+type+"][data='priceDiv'][goodsid="+goodsId+"]").hide();
			  $("#price_set_pre").find("div[class*="+type+"][data='priceDiv'][goodsid="+goodsId+"]").find("input[type=text]").attr("disabled","disabled");
			  $("#price_set_pre").find("div[class*="+type+"][data='priceDiv'][goodsid="+goodsId+"]").find("input[type=text]").val("");
			  $("#price_set_pre").find("div[class*="+type+"][data='priceDiv'][goodsid="+goodsId+"]").find("input[type=radio]").attr("disabled","disabled");
		  }		  		 
	  }else
	  {
	      var goodsid =obj.parents('div[data="priceDiv"]').attr('goodsid')
		  if(obj.attr("checked")!='checked')
		  {
		    if(num != 'all'){	      
		      $("#price_set_pre").find("div[class*="+type+"]").eq(num).show();
		      $("#price_set_pre").find("div[class*="+type+"]").eq(num).find("input[type=text]").removeAttr("disabled");	
		      checkboxPreSale(obj);
		    }else{		      	
		      $("#price_set_pre").find("div[class*="+type+"]").show();
		      $("#price_set_pre").find("div[class*="+type+"]").find("input[type=text]").removeAttr("disabled");
		      $("#price_set_pre").find("div[class*="+type+"]").find("input[type=radio]").removeAttr("disabled");
		      $("#price_set_pre").find("div[class*=isPreMod]").show();
		      $("#price_set_pre").find("div[class*=isPreMod]").find("[type=radio]").removeAttr("disabled");
		      checkboxPreSale(obj);
		    }	    	    
		  }else
		  {
		    var allChecked = false;
		    //选择禁售
		    if(num != 'all')
		    {
		      $("#price_set_pre").find("div[class*="+type+"]").eq(num).hide();
		      $("#price_set_pre").find("div[class*="+type+"]").eq(num).find("input[type=text]").attr("disabled","disabled");
		      $("#price_set_pre").find("div[class*="+type+"]").eq(num).find("input[type=text]").val("");
		      checkboxPreSale(obj);
		    }else{
		      //全选禁售	      
		      $("#price_set_pre").find("div[class*="+type+"]").hide();
		      $("#price_set_pre").find("div[class*="+type+"]").find("input[type=text]").attr("disabled","disabled");
		      $("#price_set_pre").find("div[class*="+type+"]").find("input[type=text]").val("")
		      $("#price_set_pre").find("div[class*="+type+"]").find("input[type=radio]").attr("disabled","disabled");
		      checkboxPreSale(obj);
		      allChecked = true;
		    }	    
		  }	
		  
		  //两个都禁用
		  var alength = $("input[type=checkbox][class*=JS_checkbox_lock_item][data=saleAble][name=adult]:checked").length;
		  var clength = $("input[type=checkbox][class*=JS_checkbox_lock_item][data=saleAble][name=child]:checked").length;
		  if((parseInt(alength)>0 && parseInt(clength)>0) || allChecked){
		    $("#price_set_pre").find("div[class*=isPreMod]").find("[type=radio]").attr("disabled","disabled");
		    $("#price_set_pre").find("div[class*=isPreMod]").hide();
		  }else
		  {
		   	$("#price_set_pre").find("div[class*=isPreMod]").find("[type=radio]").removeAttr("disabled");
		    $("#price_set_pre").find("div[class*=isPreMod]").show();
		  }
	  }
 }
   function checkboxPreSale(obj){
   var goodsid =obj.parents('div[data="priceDiv"]').attr('goodsid')
   var list=obj.parents('div.clearfix.product-lock-up').find("input[type='checkbox']");
     var adultFlag =false;
     var childFlag=false;
     var gapFlag=false;
     var allFlag=false;
     list.each(function(i){
      var inputchecked= list.eq(i).attr("checked");
       if( inputchecked=='checked' ){
        var inputName= $(this).attr("name");
         if(inputName=='adult'){
         adultFlag=true;
         }else if(inputName=='child'){
         childFlag=true;
         }else if(inputName=='gap'){
         gapFlag=true;
         }else if(inputName=='multiple_price_limit'){
         allFlag=true;
         }
       }
    });
      $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+goodsid+"']").removeAttr("disabled");
      $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+goodsid+"']").removeAttr("disabled");
      $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+goodsid+"']").val("");
      $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+goodsid+"']").val("");
    if(allFlag&&!adultFlag&&!childFlag&&!gapFlag){
     $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+goodsid+"']").attr("disabled","disabled");
	 $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+goodsid+"']").val("");
	 $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+goodsid+"']").attr("disabled","disabled");
	 $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+goodsid+"']").val("");
    }else if(adultFlag&&!allFlag&&!childFlag&&!gapFlag){
     $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+goodsid+"']").attr("disabled","disabled");
	 $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+goodsid+"']").val("");
     }else if(childFlag&&!adultFlag&&!gapFlag&&!allFlag){
     $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+goodsid+"']").attr("disabled","disabled");
	 $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+goodsid+"']").val("");
    }else if(adultFlag&&childFlag&&!gapFlag&&!allFlag){
    $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+goodsid+"']").attr("disabled","disabled");
	 $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+goodsid+"']").val("");
	 $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+goodsid+"']").attr("disabled","disabled");
	 $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+goodsid+"']").val("");
    }else if(gapFlag&&adultFlag&&childFlag&&!allFlag){
     $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+goodsid+"']").attr("disabled","disabled");
	 $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+goodsid+"']").val("");
	 $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+goodsid+"']").attr("disabled","disabled");
	 $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+goodsid+"']").val("");
    }else if(gapFlag&&adultFlag&&!childFlag&&!allFlag){
     $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+goodsid+"']").attr("disabled","disabled");
	 $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+goodsid+"']").val("");
    }else if(gapFlag&&!adultFlag&&childFlag&&!allFlag){
     $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+goodsid+"']").attr("disabled","disabled");
	 $("#Set_PreSale").find("div[goodsId='"+goodsid+"'][data=preSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+goodsid+"']").val("");
    }
   }
    //自动根据库存类型判断是否删除对应的买断设置
    
	//根据库存类型判断是否删除对应的买断设置
	function deletePreControlByType(obj){
		 var parentDiv = obj.parents('div[data="stockDiv"]');
		 var goodsId = parentDiv.attr('goodsid');
		 var val = obj.val();
		 var radio1="radio1"+goodsId;
		 var radio2="radio2"+goodsId;
		 var preDiv = $("#price_set_pre").find('div[goodsid='+goodsId+']');
		 //现询
		 if(val=='INQUIRE_WITH_STOCK' ||val=='INQUIRE_NO_STOCK')
		 {
		    $("#price_set_pre").find("div[div='goodControl"+goodsId+"']").show();
		    var useBudgeDiv = $("#price_set_pre").find("div[div='useBudgePriceDiv"+goodsId+"']");
		    var useBudgeRadios = useBudgeDiv.find(":radio");
		    useBudgeDiv.show();
		    useBudgeRadios.eq(0).removeAttr("checked").attr("disabled","disabled")
		    useBudgeRadios.eq(1).attr("checked","checked").attr("disabled","disabled");
		    
		    showPreControl(useBudgeRadios.eq(1));
		    if($('#'+radio1).is(":checked")||$('#'+radio2).is(":checked")){
	        $("div[div=useBudgePriceDiv"+goodsId+"]").hide();
		    }
		 }else
		 {		   
		    var nameStr = 'isPreControlPrice'+goodsId;	
		    var nameStr1='useBudgePrice'+goodsId;	  
		    var obj = $("input[name="+nameStr+"][type=radio][class*=closeBudgePrice]:checked");
		    var obj1=$("input[name="+nameStr1+"][type=radio][class*=notUseBudgePrice]");
		    preDiv.show();
		    preDiv.find("input[type=radio]").removeAttr("disabled");
		    if(obj.val()=='Y')
		    {		     
		     preDiv.find("input[type=text]").removeAttr("disabled");
		    }
		    if(obj.val()=='N'){
		    $("div[div=useBudgePriceDiv"+goodsId+"]").hide();
		    
		   
		    }	   
		    if(obj1.is(":checked")){
		    showPreControl(obj1);
		    }	
		     if(obj.val()=='N'){
		     $("div[div=useBudgePriceDiv"+goodsId+"]").hide();
		
		   
		    }		   
		 }

	}
	
	function hidePreControl(goodsId){
		  var nameStr = 'isPreControlPrice'+goodsId;		  
		  var obj = $("input[name="+nameStr+"][type=radio][value=N][class*=closeBudgePrice]");	
		  var nameStr1 = 'isPreControlDiv'+goodsId;
		  showPreDom(obj);
		  $("#price_set_pre").find("div[class*=forbidSaleSingle][goodsid="+goodsId+"]").find("input[type=text]").attr("disabled","disabled");
		  $("#price_set_pre").find("div[class*="+nameStr1+"]").find("input[type=text]").attr("disabled","disabled");		  
  }
  //设置是否预售
  function toIsPreSale(obj){
     var parentDiv = obj.parents('div[data="preSaleDiv"]');
	 var goodsId = parentDiv.attr('goodsid');
	 var val = obj.val();
	 if(val=='Y'){
	 $('div.isPreSaleDiv'+goodsId).show();
	 }else{
	  $('div.isPreSaleDiv'+goodsId).hide();
	 }
  }
  /*
   * 点击选择日期日历的出发时间，
   * 由于这里的日历和日历输入框的样式公用，需要判断点击的是日历还是日历输入框
   */
  
  $('.caldate').live('click',function(){
  		var selectCalendar = $('input[name=dateType]:checked').val();
  		if(selectCalendar!="selectDate"){
  			return;
  		}
  		var tee=[]; //缓存已输入的日期
  		var caldateFalg=false;
  		var forFlag=true;
  		var obj=$(this).parent();
  		for(var i=0;forFlag;i++){
  			obj=obj.parent();
  			if(obj.attr("id")=="timePriceForm"  ){
  				caldateFalg=true;
  				forFlag=false;
  			}if(obj.html()==null){
  				forFlag=false;
  			}
  			if(caldateFalg){
  				var tempDate=$(this).parent().attr("date-map"); //获取去日历上的时间
				var tempFalg=false; //用户判断是移除日期还是添加日期  ，如果已经选择的日期则移除，否则添加
				
				$("#optionDate option").each(function(){
					if(tempDate==$(this).val()){
						tempFalg=true;
					}
					
				});
				if(tempFalg){
					var liHtml='<li id="item'+tempDate.replace(/-/gm,"")+'" goDate="'+tempDate+'" style="width:300px;height:25px;margin:5px;float:left;display:block;margin-right:100px;">'+tempDate+':<input id="dItem'+tempDate.replace(/-/gm,"")+'" class="datetime form-control w120 J_calendar2" type="text">  17:30</li>';
					$("#upDocLstMain li").each(function(){
						var teeItem={};
						teeItem.value=($(this).find("input")).val();
						teeItem.id=($(this).find("input")).attr("id");
						tee.push(teeItem);
					});
					$("#upDocLstMain").html($("#upDocLstMain").html()+liHtml);//添加上传材料输入框
					for(var i=0;i<tee.length;i++){ //将缓存的已经输入的日期，重新赋值给相应的日历输入框
						//$("#"+).val(tee.value);
						$("#"+tee[i].id+"").val(tee[i].value);
					}
					
				}else{
					$("#item"+tempDate.replace(/-/gm,"")).remove();
				}
				reDrawingCalendar();
  			}
  		}
		
	});
	
	$("#d4321").live('change',function(){
		var tee=[]; //缓存已输入的日期
		var selectCalendar = $('input[name=dateType]:checked').val();
		if(selectCalendar=="selectTime"){
			var sdateStr=$(this).val();
			var edateStr=$("#d4322").val();
			if(edateStr==null || edateStr==""){
				return;
			}
			$("#upDocLstMain li").each(function(){
				var teeItem={};
				teeItem.value=($(this).find("input")).val();
				teeItem.id=($(this).find("input")).attr("id");
				tee.push(teeItem);
			});
			var dates=DateDiffDays(sdateStr, edateStr);
			var oldUdlm="";
			for(var i=0;i<dates.length;i++){
				oldUdlm+='<li id="item'+dates[i].replace(/-/gm,"")+'" goDate="'+dates[i]+'" style="width:300px;height:25px;margin:5px;float:left;display:block;margin-right:100px;">'+dates[i]+':<input id="dItem'+dates[i].replace(/-/gm,"")+'" class="datetime form-control w120 J_calendar2" type="text">  17:30</li>';
			}
			$("#upDocLstMain").html(oldUdlm);
			for(var i=0;i<tee.length;i++){ //将缓存的已经输入的日期，重新赋值给相应的日历输入框
				//$("#"+).val(tee.value);
				$("#"+tee[i].id+"").val(tee[i].value);
			}
		}
		reDrawingCalendar();
		
	});
	
	$("#d4322").live('change',function(){
		var tee=[]; //缓存已输入的日期
		var selectCalendar = $('input[name=dateType]:checked').val();
		if(selectCalendar=="selectTime"){
			var sdateStr=$("#d4321").val();
			if(sdateStr==null || sdateStr==""){
				return;
			}
			var edateStr=$(this).val();
			$("#upDocLstMain li").each(function(){
				var teeItem={};
				teeItem.value=($(this).find("input")).val();
				teeItem.id=($(this).find("input")).attr("id");
				tee.push(teeItem);
			});
			var dates=DateDiffDays(sdateStr, edateStr);
			var oldUdlm="";
			for(var i=0;i<dates.length;i++){
				oldUdlm+='<li id="item'+dates[i].replace(/-/gm,"")+'" goDate="'+dates[i]+'" style="width:300px;height:25px;margin:5px;float:left;display:block;margin-right:100px;">'+dates[i]+':<input id="dItem'+dates[i].replace(/-/gm,"")+'" class="datetime form-control w120 J_calendar2" type="text">  17:30</li>';
			}
			$("#upDocLstMain").html(oldUdlm);
			for(var i=0;i<tee.length;i++){ //将缓存的已经输入的日期，重新赋值给相应的日历输入框
				//$("#"+).val(tee.value);
				$("#"+tee[i].id+"").val(tee[i].value);
			}
		}
		reDrawingCalendar();
		
	});
	
	var firtFalg=false; //是否是首次点击上传材料的tab
	$('#upDoclastTimeTab').live('click',function(){
		var selectCalendar = $('input[name=dateType]:checked').val();
		if(selectCalendar=="selectDate"){
			if(firtFalg=false){
				var oldUdlm="";
				$("#optionDate option").each(function(){
				
					oldUdlm+='<li id="item'+$(this).val().replace(/-/gm,"")+'" goDate="'+$(this).val()+'" style="width:300px;height:25px;margin:5px;float:left;display:block;margin-right:100px;">'+$(this).val()+':<input id="dItem'+$(this).val().replace(/-/gm,"")+'" class="datetime form-control w120 J_calendar2" type="text">  17:30</li>';
				});
				$("#upDocLstMain").html(oldUdlm);
				firtFalg=true;
			}
		}else{
			if(firtFalg=false){
				var sdateStr=$("#d4321").val();
				var edateStr=$("#d4322").val();
				if(sdateStr==null || sdateStr==""){
					alert("请输入开始日期");
					$(this).class("");
					return;
				}
				if(edateStr == null || edateStr==""){
					alert("请输入结束日期");
					$(this).class("");
					return;
				}
				var dates=DateDiffDays(sdateStr, edateStr);
				var oldUdlm="";
				for(var i=0;i<dates.length;i++){
					oldUdlm+='<li id="item'+dates[i].replace(/-/gm,"")+'" goDate="'+dates[i]+'" style="width:300px;height:25px;margin:5px;float:left;display:block;margin-right:100px;">'+dates[i]+':<input id="dItem'+dates[i].replace(/-/gm,"")+'" class="datetime form-control w120 J_calendar2" type="text">  17:30</li>';
				}
				$("#upDocLstMain").html(oldUdlm);
			}
		}
		reDrawingCalendar(); //重新渲染日历控件
		
	});
	
	/*
	*获取两个日期之间的日期
	*return ： 数组
	*params ： sdateStr=开始时间字符 ，edateStr结束时间字符
	*/
	function DateDiffDays(sdateStr, edateStr){ //sdateStr和edateStr是字符串 yyyy-MM-dd格式 
		var array = new Array();
		var sdate,edate
		var sdateTmp=sdateStr.split("-");
		var edateTmp=edateStr.split("-");
		sdate=new Date(sdateStr)
		edate=new Date(edateStr)
		var TotalMilliseconds = Math.abs(edate.getTime() - sdate.getTime());//相差的毫秒数
		var days= parseInt(TotalMilliseconds / 1000 / 60 / 60 /24);//两个日期间隔多少天
		for(var i=0;i<=days;i++){
			var tmpDate=new Date(sdate.getTime()+(86400000*i));
			var year=tmpDate.getFullYear ();
			var month=tmpDate.getMonth ()+1;
			var day= tmpDate.getDate ();
    		var dateStr = year + "-" ;
    		if ( month >= 10 ){
				dateStr = dateStr + month + "-" ;
			}else{
         		dateStr = dateStr + "0" + month + "-" ;
    		}
    		if ( day >= 10 ){
        		dateStr = dateStr + day ;
    		}else{
				dateStr = dateStr + "0" + day ;
    		}
    		array.push(dateStr);
		}
		return array;
	}
	function reDrawingCalendar(){ //由于js加载日历框需要重新渲染一下
		pandora.calendar({
            mos: 25,
            trigger: '.J_calendar2',
            isRange: false,
            frequent: true,
            cascade: {
                days: 0,
                trigger: '.J_calendar2'
            },
            isTodayClick: true,
            template: 'small',
            offsetAmount:{left:0,top:-278}
        });
	}
	var scTemp = $('input[name=dateType]:checked').val();	//获取取单选按钮的初始值
	function clearUpDocLastTime(dataType){
		if(scTemp==dataType){
			return ;
		}else{
			$("#upDocLstMain").html("");
		}
		scTemp=dataType;
	}
	
	function setUpDocLastTime(){
		var resFlag=true;
		$("#upDocLastTimeContent").html("");
		$("#upDocLstMain li").each(function(){
			if($(this).find("input").val()!=""){
				$("#upDocLastTimeContent").append('<input type="hidden" name="upDocLastTime" value="'+$(this).attr("goDate")+"|"+$(this).find("input").val()+'">');
			}else{
				resFlag=false;
			}
		});
		return resFlag;
	}
</script>
</body>
</html>
