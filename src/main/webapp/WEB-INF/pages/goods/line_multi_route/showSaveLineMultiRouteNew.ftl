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

<div class="single-product">
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local'|| categoryCode=='category_route_customized'>
	<#assign adultChildGoods = goodsMap['adult_child_diff'] />
	<#if adultChildGoods??>
    <div class="row">
	 		<div class="col w80 mr10 text-right text-gray">成人儿童：</div>
		 		 <div class="col w650">
		 		 	
			            <label class="checkbox">
			                <input type="checkbox" id="suppGoodsId_flag" class="checkGoods adult_child" name="suppGoodsId" value="${adultChildGoods.suppGoodsId}" data_name="${adultChildGoods.goodsName}" data_price_type="${adultChildGoods.priceType}" supplier_id="${adultChildGoods.supplierId}"/>${adultChildGoods.goodsName}[${adultChildGoods.suppGoodsId}]
			            </label>
			          
	            </div>
    </div>
     </#if> 
</#if>
 <#if categoryCode=='category_route_hotelcomb'>
 	 <#assign comboDinnerList = goodsMap['combo_dinner'] />
 	 <#if comboDinnerList?? && comboDinnerList?size gt 0>
 	
    <div class="row">
		
 			<div class="col w80 mr10 text-right text-gray">套餐：</div>
 			<div class="col w650">
		 		<#list comboDinnerList as comboDinnerGoods>
		 			<label class="checkbox" <#if comboDinnerGoods.cancelFlag!='Y'>cancelFlag="Y"</#if> > 
		 				<input type="checkbox" class="checkGoods comb_hotel" name="suppGoodsId" value="${comboDinnerGoods.suppGoodsId}"  data_name="${comboDinnerGoods.goodsName}" data_price_type="${comboDinnerGoods.priceType}" />${comboDinnerGoods.goodsName}[${comboDinnerGoods.suppGoodsId}]
		 			</label>
		 			<#assign mainProdBranchId = '${comboDinnerGoods.productBranchId}' />
	 				<#assign mainSuppGoodsId = '${comboDinnerGoods.suppGoodsId}' />
		 		</#list>
		    </div>		 
    </div>
    </#if>
 </#if>	
 
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_hotelcomb'|| categoryCode=='category_route_customized'>
    <#assign additionList = goodsMap['addition'] />
    <#if additionList?? && additionList?size gt 0>
    <div class="row">
			<div class="col w80 mr10 text-right text-gray">附加：</div>
			<div class="col w650">
				
		 		<#list additionList as additionGoods>
		 			<label class="checkbox" <#if additionGoods.cancelFlag!='Y'>cancelFlag="Y"</#if>  >
		 			    
		 			    <input type="checkbox" class="checkGoods addition" name="suppGoodsId" value="${additionGoods.suppGoodsId}"  data_name="${additionGoods.goodsName}" data_price_type="${additionGoods.priceType}" />${additionGoods.goodsName}[${additionGoods.suppGoodsId}]
		 			</label>
		 		</#list>
		 	</div>	
	</div>
	</#if>

</#if> 
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'|| categoryCode=='category_route_customized'>
    <#assign upgradList = goodsMap['upgrad'] />
    <#if upgradList?? && upgradList?size gt 0 >
    <div class="row">
	 		<div class="col w80 mr10 text-right text-gray">升级：</div>
	 		<div class="col w650">
		 		
		 		<#list upgradList as upgradGoods>
		 			<label class="checkbox">
		 				<input type="checkbox" class="checkGoods upgrade" name="suppGoodsId" value="${upgradGoods.suppGoodsId}"  data_name="${upgradGoods.goodsName}" data_price_type="${upgradGoods.priceType}" />${upgradGoods.goodsName}[${upgradGoods.suppGoodsId}]
		 			</label>
		 		</#list>
	 		</div>	
    </div>
    </#if>
</#if>	
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'|| categoryCode=='category_route_customized'>
	<#assign changedHotelList = goodsMap['changed_hotel'] />
	<#if changedHotelList?? && changedHotelList?size gt 0 >
  
    <div class="row">

	 		<div class="col w80 mr10 text-right text-gray">可换酒店：</div>
	 		<div class="col w650">
		 		<#list changedHotelList as changedHotelGoods>
		 			<label class="checkbox">
		 				<input type="checkbox" class="checkGoods change_hotel" name="suppGoodsId" value="${changedHotelGoods.suppGoodsId}"  data_name="${changedHotelGoods.goodsName}" data_price_type="${changedHotelGoods.priceType}" />${changedHotelGoods.goodsName}[${changedHotelGoods.suppGoodsId}]
		 			</label>
		 		</#list>
	 		</div>					
    </div>
    </#if>
    
</#if>	    

<div class="hr"></div>
  <form id="timePriceForm">
        
        <div class="row">
            <div class="col w80 mr10 text-right text-gray">
                出行日期：
            </div>
            <div class="col w490 text-gray">
				${spec_date}
				<input type="hidden" value="${spec_date}" id="spec_date"/>
            </div>
            <div class="col">
                <label>
                    适用行程：                    
                 	<select class="w80 form-control" name="lineRouteId">
	                        <#if prodLineRoutes?? && prodLineRoutes?size &gt; 0>
	                        	<option value=''>请选择</option>
	                        	<#list prodLineRoutes as prodLineRoute>
	                        		<#assign isTrue =0 />
	                        		
									<option <#if isTrue==1>selected='selected'</#if> value='${prodLineRoute.lineRouteId}'  >${prodLineRoute.routeName}</option>
								</#list>
							
								    
							</#if>
                    </select>
                </label>
            </div>
        </div>
        	<input type="hidden" name="adult" id="adult">
            <input type="hidden" name="child" id="child">
        	<input type="hidden" name="isSetPrice">
			<input type="hidden" name="isSetStock">
			<input type="hidden" name="isSetAheadBookTime">
        	<input type="hidden" name="nfadd_date" value="selectDate">
        	<input type="hidden" name="selectDates[0]" id="selectDates_low">
            <input type="hidden" name="gap" id="gap">
            <input type="hidden" name="cancelStrategy" id="cancelStrategy" value="${cancelStrategy!''}">
            <input type="hidden" name="lineRouteIdBack" value="${lineRouteId!''}">
            <input type="hidden" id="thisCategoryId" value="${categoryId!''}">
            <div style="display:none" id="timePriceFormContent"></div>
 </form>
     
     <div class="hr"></div>
        
  	<form id="timePriceFormInput">

            	


            <!--设置价格 开始-->
            
<!--成人儿童价格模板-->            
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local'|| categoryCode=='category_route_customized'>
    <#assign adultChildGoods = goodsMap['adult_child_diff'] />
 			<#if adultChildGoods??>
			    <div class="row" goodsId="${adultChildGoods.suppGoodsId}" data="priceDiv" divTag="adult_child_diff">
			    </div>	    
			</#if>			    			    
</#if>


<!--套餐价格模板-->
<#if categoryCode=='category_route_hotelcomb'>
	<#assign comboDinnerList = goodsMap['combo_dinner'] />
		 <#list comboDinnerList as comboDinnerGoods>
		 	    <#if comboDinnerGoods??>
			    <div class="row JS_price_group" goodsId="${comboDinnerGoods.suppGoodsId}" data="priceDiv" divTag="combo_dinner">
			    </div>	
				</#if>
		  </#list>

</#if>


<!--附加价格模板-->

<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_hotelcomb'|| categoryCode=='category_route_customized'>

				<#assign additionList = goodsMap['addition'] />
		 		<#list additionList as additionGoods>
			    	<#if additionGoods??>
			    	<div class="row JS_price_group" goodsId="${additionGoods.suppGoodsId}" data="priceDiv" divTag="addition">
			    	</div>
			    	</#if>	
			    	
		 		</#list>
</#if> 
<!--升级价格模板-->
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'|| categoryCode=='category_route_customized'>
    <#assign upgradList = goodsMap['upgrad'] />	
    			<#if upgradList?? &&upgradList?size gt 0 >
		 		<#list upgradList as upgradGoods>
					<div class="row" goodsId="${upgradGoods.suppGoodsId}" data="priceDiv" divTag="upgrad">
			    	</div>	
		 		</#list>
		 		</#if>
</#if>

<!--升级可换酒店价格模板-->	
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'|| categoryCode=='category_route_customized'>
		 		<#assign changedHotelList = goodsMap['changed_hotel'] />
		 		<#list changedHotelList as changedHotelGoods>
		 			<div class="row" goodsId="${changedHotelGoods.suppGoodsId}" data="priceDiv" divTag="changed_hotel">
			    	</div>	
		 		</#list>
</#if>	    
            <!--设置价格 结束-->
       
<div class="hr" style="display:none" name="isShowLine"></div>
<!-- 设置买断模板 -->
 <div  class="row" id="price_set_pre">
 

<!--成人儿童价格模板-->            
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local'|| categoryCode=='category_route_customized'>
    <#assign adultChildGoods = goodsMap['adult_child_diff'] />
 			<#if adultChildGoods??>
			    <div class="row" goodsId="${adultChildGoods.suppGoodsId}" data="pricePreDiv" divPreTag="adult_child_diff">
			    </div>	    
			</#if>			    			    
</#if>

 <!--设置预售价格 开始-->
 <div class="hr" style="display:none" name="isShowLine"></div>
        <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local'|| categoryCode=='category_route_customized'>
        <#assign adultPreSaleChildGoods = goodsMap['adult_child_diff'] />
 			<#if adultPreSaleChildGoods??>
			    <div class="row" goodsId="${adultPreSaleChildGoods.suppGoodsId}" data="onePreSaleDiv" >
			    </div>	
			    
			</#if>
		</#if>
         
          <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'|| categoryCode=='category_route_customized'>
		 	<#assign changedHotelPreSaleList = goodsMap['changed_hotel'] />
		 	<#list changedHotelPreSaleList as changedHotelPreSaleGoods>
		 			<div class="row" goodsId="${changedHotelPreSaleGoods.suppGoodsId}" data="onePreSaleDiv" >
			    </div>		
		 	</#list>
           </#if>
       <!--设置预售价格 结束-->
<!--套餐价格模板-->
<#if categoryCode=='category_route_hotelcomb'>
	<#assign comboDinnerList = goodsMap['combo_dinner'] />
		 <#list comboDinnerList as comboDinnerGoods>
		 	    <#if comboDinnerGoods??>
			    <div class="row JS_price_group" goodsId="${comboDinnerGoods.suppGoodsId}" data="pricePreDiv" divPreTag="combo_dinner">
			    </div>	
				</#if>
		  </#list>

</#if>
</div>


<!--附加价格模板-->

<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_hotelcomb'|| categoryCode=='category_route_customized'>

				<#assign additionList = goodsMap['addition'] />
		 		<#list additionList as additionGoods>
			    	<#if additionGoods??>
			    	<div class="row JS_price_group" goodsId="${additionGoods.suppGoodsId}" data="pricePreDiv" divPreTag="addition">
			    	</div>
			    	</#if>	
			    	
		 		</#list>
</#if> 
<!--升级价格模板-->
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'|| categoryCode=='category_route_customized'>
    <#assign upgradList = goodsMap['upgrad'] />	
    			<#if upgradList?? &&upgradList?size gt 0 >
		 		<#list upgradList as upgradGoods>
					<div class="row" goodsId="${upgradGoods.suppGoodsId}" data="pricePreDiv" divPreTag="upgrad">
			    	</div>	
		 		</#list>
		 		</#if>
</#if>

<!--升级可换酒店价格模板-->	
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'|| categoryCode=='category_route_customized'>
		 		<#assign changedHotelList = goodsMap['changed_hotel'] />
		 		<#list changedHotelList as changedHotelGoods>
		 			<div class="row" goodsId="${changedHotelGoods.suppGoodsId}" data="pricePreDiv" divPreTag="changed_hotel">
			    	</div>	
		 		</#list>
</#if>	


<div class="hr" style="display:none" name="isShowLine"></div>

<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local'|| categoryCode=='category_route_customized'>
    <#assign adultChildGoods = goodsMap['adult_child_diff'] />
 			<#if adultChildGoods??>
			    <div class="row JS_radio_switch_group" goodsId="${adultChildGoods.suppGoodsId}" data="stockDiv">
			    </div>
			    
			</#if>
			 
			    			    
</#if>
<!--套餐库存模板-->
<#if categoryCode=='category_route_hotelcomb'>
	<#assign comboDinnerList = goodsMap['combo_dinner'] />
		 <#list comboDinnerList as comboDinnerGoods>
		 	    <#if comboDinnerGoods??>
			    <div class="row JS_radio_switch_group" goodsId="${comboDinnerGoods.suppGoodsId}" data="stockDiv">
			    </div>
				</#if>
		  </#list>

</#if>


<!--附加库存模板-->

<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_hotelcomb'|| categoryCode=='category_route_customized'>

				<#assign additionList = goodsMap['addition'] />
		 		<#list additionList as additionGoods>
		 			<div class="row JS_radio_switch_group" goodsId="${additionGoods.suppGoodsId}" data="stockDiv">
		 			
			    	</div>
		 		</#list>
</#if> 
<!--升级库存模板-->
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'|| categoryCode=='category_route_customized'>
    <#assign upgradList = goodsMap['upgrad'] />
    			<#if upgradList?? &&upgradList?size gt 0 >
		 		<#list upgradList as upgradGoods>
					<div class="row JS_radio_switch_group" goodsId="${upgradGoods.suppGoodsId}" data="stockDiv">
		 			
			    	</div>
		 		</#list>
		 		</#if>
</#if>

<!--可换酒店库存模板-->	
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'|| categoryCode=='category_route_customized'>
		 		<#assign changedHotelList = goodsMap['changed_hotel'] />
		 		<#list changedHotelList as changedHotelGoods>
		 			<div class="row JS_radio_switch_group" goodsId="${changedHotelGoods.suppGoodsId}" data="stockDiv">
		 				
			    	</div>
		 		</#list>
</#if>	            	
       
            <!--设置库存 结束-->

<div class="hr" style="display:none" name="isShowLine"></div>


            <!--设置提前预定时间 开始-->
            
<!--成人儿童提前预定时间模板-->            
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local'|| categoryCode=='category_route_customized'>
    <#assign adultChildGoods = goodsMap['adult_child_diff'] />
 			<#if adultChildGoods??>
		         <div  goodsId="${adultChildGoods.suppGoodsId}"  class="row" data="timeDiv_date" ></div>
                 <div  goodsId="${adultChildGoods.suppGoodsId}"  class="row" data="timeDiv_limit"></div>			    
			</#if>			    			    
</#if>
<!--套餐提前预定时间模板-->
<#if categoryCode=='category_route_hotelcomb'>
	<#assign comboDinnerList = goodsMap['combo_dinner'] />
		 <#list comboDinnerList as comboDinnerGoods>
		 	    <#if comboDinnerGoods??>
			         <div  goodsId="${comboDinnerGoods.suppGoodsId}"  class="row" data="timeDiv_date" ></div>
                     <div  goodsId="${comboDinnerGoods.suppGoodsId}"  class="row" data="timeDiv_limit"></div>	
				</#if>
		  </#list>

</#if>


<!--附加提前预定时间模板-->

<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_hotelcomb'|| categoryCode=='category_route_customized'>

				<#assign additionList = goodsMap['addition'] />
		 		<#list additionList as additionGoods>
			    	<#if additionGoods??>
			    	    <div  goodsId="${additionGoods.suppGoodsId}"  class="row" data="timeDiv_date" ></div>
                        <div  goodsId="${additionGoods.suppGoodsId}"  class="row" data="timeDiv_limit"></div>	
			    	</#if>	
			    	
		 		</#list>
</#if> 
<!--升级提前预定时间模板-->
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'|| categoryCode=='category_route_customized'>
    <#assign upgradList = goodsMap['upgrad'] />	
    <#if upgradList?? &&upgradList?size gt 0 >
		 		<#list upgradList as upgradGoods>
			    	 <div  goodsId="${upgradGoods.suppGoodsId}"  class="row" data="timeDiv_date" ></div>
                     <div  goodsId="${upgradGoods.suppGoodsId}"  class="row" data="timeDiv_limit"></div>	
		 		</#list>
	</#if>	 		
</#if>

<!--升级可换酒店提前预定时间模板-->	
<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'|| categoryCode=='category_route_customized'>
		 		<#assign changedHotelList = goodsMap['changed_hotel'] />
		 		<#list changedHotelList as changedHotelGoods>			    	
			    	 <div  goodsId="${changedHotelGoods.suppGoodsId}"  class="row" data="timeDiv_date" ></div>
                     <div  goodsId="${changedHotelGoods.suppGoodsId}"  class="row" data="timeDiv_limit"></div>
		 		</#list>
</#if>	                
            
            <!--设置提前预定时间 结束-->
            
            <!-- 材料截止收取时间 开始 -->
            <#if productType=='FOREIGNLINE' && packageType=='SUPPLIER'>
	            <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'|| categoryCode=='category_route_customized'>
	            <div class="hr" style="display:none" name="isShowLine"></div>                  
					<div class="row">
	                <div class="col w110 text-right text-gray pr10">
	                   		材料截止收取时间：
	                </div>
	                <div class="col w250">
	                    <input type="text" <#if lastDate??> value="${lastDate?string('yyyy-MM-dd')!''}"</#if> class="datetime form-control w170 J_calendar2" name="last_date" id="last_date" /> 17:30
	                </div>
            	</div>
	            </#if>
            </#if>
            
			<!-- 材料截止收取时间 结束 -->

            
<div class="hr" style="display:none" name="isShowLine"></div>                  
   <div class="row">
   
            <div class="col w110 mr10 text-right text-gray">退改规则：</div>
            <div class="col w100 pl10">
                <label class="radio">
                    <input type="radio" checked name="retreatRule" data="selectCancelStrategy" value="MANUALCHANGE" <#if cancelStrategy?? && cancelStrategy =='MANUALCHANGE'>checked</#if>  />
                    人工退改
                </label>
            </div>
            <div class="col w100">
                <label class="radio">
                    <input type="radio" name="retreatRule"  data="selectCancelStrategy" value="UNRETREATANDCHANGE" <#if cancelStrategy?? && cancelStrategy =='UNRETREATANDCHANGE'>checked</#if> />
                    不退不改
                </label>
            </div>
     </div>     
        
  </form>
  
     
  
  
    <div class="row">
        <div class="btn-group text-center">
            <a class="btn btn-primary btn-lg JS_btn_save" id="singleSave">保存</a>
            <a class="btn btn-lg JS_btn_cancel" id="singleCancel">取消</a>
        </div>
    </div>
</div>

<div id="allTemplates" style="display:none">
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
                                <select class="w85 form-control JS_price_rule" notnumber="Y" name="adultPriceRule{isInput}">
                                    <option value="custom">自定义</option>
                                    <option value="fixed">固定加价</option>
                                    <option value="percent">比例加价</option>
                                    <option value="equal">结=售</option>
                                </select>
                            </div>
                            <div class="col w80">
                            	<div class="form-group">
                                <input class="w50 form-control JS_price_added" data-validate="{regular:true}" name="adultReadOnlyNum{isInput}"
                                       data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" type="text" readonly
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
                                <select class="w85 form-control JS_price_rule"  notnumber="Y" name="childPriceRule{isInput}">
                                    <option value="custom">自定义</option>
                                    <option value="fixed">固定加价</option>
                                    <option value="percent">比例加价</option>
                                    <option value="equal">结=售</option>
                                </select>
                            </div>
                            <div class="col w80">
                                <div class="form-group">
                                    <input class="w50 form-control JS_price_added" data-validate="{regular:true}" name="childReadOnlyNum{isInput}"
                                           data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" type="text" readonly
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
                                                  data_type="is_input" goods="child{isInput}" data-validate-readonly="true"/>
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
                                <select class="w85 form-control JS_price_rule"  notnumber="Y">
                                    <option value="custom">自定义</option>
                                    <option value="fixed">固定加价</option>
                                    <option value="percent">比例加价</option>
                                    <option value="equal">结=售</option>
                                </select>
                            </div>
                            <div class="col w80">
                                <div class="form-group">
                                    <input class="w50 form-control JS_price_added" data-validate="{regular:true}"
                                           data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" type="text" readonly/>
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

                            <div class="col w70" style="{isShowOne}" id="jinshouDiv">
                                <div class="mb10">
                                    <div class="form-group">
                                        <label class="checkbox">
                                            <input type="checkbox" class="JS_checkbox_lock_item"  name="adult" id="adult1" data="saleAble" goods="adult{isInput}"    />
                                            禁售
                                        </label>
                                    </div>
                                </div>
                                <div class="mb10">
                                    <div class="form-group">
                                        <label class="checkbox">
                                            <input type="checkbox" class="JS_checkbox_lock_item" name="child"   id="child1" data="saleAble" goods="child{isInput}"  />
                                            禁售
                                        </label>
                                    </div>
                                </div>
                                <div>
                                    <div class="form-group">
                                        <label class="checkbox">
                                            <input type="checkbox" class="JS_checkbox_lock_item" name="gap" data="saleAble" goods="gap{isInput}"  />
                                            禁售
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="col w90"  >
                                <div class="product-lock-up-all form-group">
                                    <label>
                                        <input type="checkbox" class="JS_checkbox_lock_all" name="multiple_price_limit" data="saleAbleAll" goods="{isInput}"    />
                                        全部禁售
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
               
	
	
	</div>
	<!--买断的多价格模板-->
	<div id="pre_multiple_price_template_new">
        <div class="col w550">
			<div class="row text-gray"> [买断]{{}}：</div>
        	<div class="row useBind{isInput}">
        		<div class="col w110 mr10"></div>
        		 是否可预控：<input type='radio' class='closeBudgePrice' name='isPreControlPrice{isInput}' goodsId='{isInput}' value='Y' onchange='showPreDom($(this))'  />是&nbsp;
       			<input type='radio' id="radio1" class='closeBudgePrice' name='isPreControlPrice{isInput}' goodsId='{isInput}' value='N' onchange='showPreDom($(this))' checked  />否
        	</div>
        	<div class="row useMaiDuan{isInput}" div="useMaiDuan{isInput}">
        		<div id="hideShow" class="col w110 mr10"></div>
        		是否启用买断价：<input type='radio' value='Y' class="useBudgePrice" name='useBudgePrice{isInput}' goodsId='{isInput}'  onchange='showPreControl($(this))'   />是&nbsp;
     			<input id="uu1" type='radio' value='N' class="notUseBudgePrice" name='useBudgePrice{isInput}'goodsId='{isInput}'   onchange='showPreControl($(this))' checked />否&nbsp;
     			<#if categoryCode=='category_route_group' || categoryCode=='category_route_local'>
     				<a class="btn" id="syncPrice" style="display:none" goodsId='{isInput}'  onclick='syncBudgePrice($(this))'>价格同步</a>
     			</#if>
        	</div>
          	<div class="col w550 useMaiDuan{isInput}" >
            	<div class="row JS_price_group adultPrePrice{isInput}">
	                <div class="col w110 mr10 text-right text-gray"></div>
	                <div class="col w50">成人价</div>
	                <div class="col w100">
	                    <div class="form-group">
	                        <label>
	                   			      结算：<input class="w50 form-control JS_price_settlement"
	                              data-validate="{regular:true}"
	                              data-validate-regular="{data-validate-regular}" type="text"
	                              max="999999999" name="auditSettlementPrice_pre"  
	                              data="auditSettlementPrice_pre"
	                              data_type="is_input" goods="adult{isInput}"  id="adultSettlePrice_pre_{isInput}"/>
	                        </label>
	                    </div>
	                </div>
	                <div class="col w90">
	                    <select class="w85 form-control JS_price_rule" notnumber="Y" name="adultPriceRule_pre">
	                        <option value="custom">自定义</option>
	                        <option value="fixed">固定加价</option>
	                        <option value="percent">比例加价</option>
	                        <option value="equal">结=售</option>
	                    </select>
	                </div>
	                <div class="col w80">
	                	<div class="form-group">
	                    <input class="w50 form-control JS_price_added" data-validate="{regular:true}" name="adultReadOnlyNum_pre"
	                           data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" type="text" readonly
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
	                            		  data-validate-readonly="true" id="adultPrice_pre_{isInput}"/>
	                        </label>
	                    </div>
	                </div>
            	</div>
            
            	<div class="row JS_price_group childPrePrice{isInput}">
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
	                                       data_type="is_input" goods="child{isInput}" id="childSettlePrice_pre_{isInput}"/>
	                        </label>
	                    </div>
	                </div>
	                <div class="col w90">
	                    <select class="w85 form-control JS_price_rule"  notnumber="Y" name="childPriceRule_pre">
	                        <option value="custom">自定义</option>
	                        <option value="fixed">固定加价</option>
	                        <option value="percent">比例加价</option>
	                        <option value="equal">结=售</option>
	                    </select>
	                </div>
	                <div class="col w80">
	                    <div class="form-group">
	                        <input class="w50 form-control JS_price_added" data-validate="{regular:true}" name="childReadOnlyNum_pre"
	                               data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" type="text" readonly
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
	                                      data_type="is_input" goods="child{isInput}" data-validate-readonly="true" id="childPrice_pre_{isInput}"/>
	                        </label>
	                    </div>
	                </div>
	            </div>
            </div>
            <div style='width:100%' class='bindControlProject{isInput}'>
            	<div class="col w110 mr10"></div>
	     		<div style="float:left;">绑定预控项目：</div>	
				<input type="hidden" id="resPrecontrolIds{isInput}" name="resPrecontrolIds"/>
		       	<a class="btn" id="bindControlProject" style="display: inline-block;" goodsid="{isInput}" suppid="{supplierId}" onclick="bindControlProject($(this))">绑定</a>
		       	<div style="float:left;" id="selectPreControlName"></div>
			</div>
		</div>
	</div>
	<!--单价格模板-->
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
                        <select class="w85 form-control JS_price_rule"  notnumber="Y" name="adultPriceRule{isInput}">
                            <option value="custom">自定义</option>
                            <option value="fixed">固定加价</option>
                            <option value="percent">比例加价</option>
                            <option value="equal">结=售</option>
                        </select>
                    </div>
                    <div class="col w80">
                        <div class="form-group">
                            <input class="w50 form-control JS_price_added" data-validate="{regular:true}" name="adultReadOnlyNum{isInput}"
                                   data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" type="text" readonly/>
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
                                <input type="checkbox" name="adult" data="saleAble"  id ="adult2" goods="adult{isInput}" />
                              		  禁售
         	                 </label>
                        </div>
                    </div>
           
	
	</div>
	<!--买断单价格模板-->
	<div id="pre_single_price_template_new">
		 			<div class="row text-gray" data="additionTag"></div>
		 			<div class="row text-gray W50">[买断]{{}}</div>
		 			<div class="row useBind{isInput}">
                    	<div class="col w110 mr10"></div>
                    	 是否可预控：<input type='radio' class='closeBudgePrice' name='isPreControlPrice{isInput}' goodsId='{isInput}' value='Y' onchange='showPreDom($(this))'  />是&nbsp;
			       		<input type='radio' id="radio2" class='closeBudgePrice' name='isPreControlPrice{isInput}' goodsId='{isInput}' value='N' onchange='showPreDom($(this))' checked  />否
                    </div>
                    <div class="row useMaiDuan{isInput}"  div="useMaiDuan{isInput}">
                    	<div id="hideShow2" class="col w110 mr10"></div>
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;是否启用买断价：<input type='radio' value='Y' class="useBudgePrice" name='useBudgePrice{isInput}' goodsId='{isInput}'  onchange='showPreControl($(this))'   />是&nbsp;
			     		<input  type='radio' value='N' id="uu2" class="notUseBudgePrice" name='useBudgePrice{isInput}'goodsId='{isInput}'   onchange='showPreControl($(this))' checked />否&nbsp;
			     		<#if categoryCode=='category_route_group' || categoryCode=='category_route_local'>
			 			 	<a class="btn" id="syncPrice" style="display:none" goodsId='{isInput}'  onclick='syncBudgePrice($(this))'>价格同步</a>
			 			</#if>
                    </div>
		 			<div class="row JS_price_group adultPrePrice{isInput}">
	                    <div class="col w110 mr10 text-right text-gray" data="additionTag"></div>
	                    <div class="col w50"></div>
	                    <div class="col w100  useMaiDuan{isInput}">
	                        <div class="form-group">
	                            <label>
	                                		结算：<input class="w50 form-control JS_price_settlement" data-validate="{regular:true}"
	                                          data-validate-regular="{data-validate-regular}" type="text"
	                                          max="999999999" name="auditSettlementPrice_pre"  data="auditSettlementPrice_pre"  data_type="is_input" goods="adult{isInput}" id="adultSettlePrice_pre_{isInput}"/>
	                            </label>
	                        </div>
	                    </div>
	                    <div class="col w90 useMaiDuan{isInput}">
	                        <select class="w85 form-control JS_price_rule"  notnumber="Y" name="adultPriceRule_pre">
	                            <option value="custom">自定义</option>
	                            <option value="fixed">固定加价</option>
	                            <option value="percent">比例加价</option>
	                            <option value="equal">结=售</option>
	                        </select>
	                    </div>
	                    <div class="col w80 useMaiDuan{isInput}">
	                        <div class="form-group">
	                            <input class="w50 form-control JS_price_added" data-validate="{regular:true}" name="adultReadOnlyNum_pre"
	                                   data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" type="text" readonly/>
	                                   <span class="JS_price_percent">%</span>
	                        </div>
	                    </div>
	                    <div class="col w110">
	                        <div class="form-group useMaiDuan{isInput}">
	                            <label>
	                               		 销售：<input class="w50 form-control JS_price_selling" data-validate="{regular:true}"
	                                          data-validate-regular="{data-validate-regular}" type="text"
	                                          max="999999999" name="auditPrice_pre" data="auditPrice_pre" data_type="is_input" goods="adult{isInput}"
	                                          data-validate-readonly="true" id="adultPrice_pre_{isInput}"/>
	                            </label>
	                        </div>
	                    </div>
	            	</div>
	
	</div>
	<!--多价格库存模板-->
	
	<div id="multiple_stock_template_new">
       		 <div class="col w110 mr10 text-right text-gray">{{}}</div>
                    <div class="JS_radio_switch_box">
            <#if (productType=='INNERSHORTLINE'|| productType=='INNERLONGLINE' || productType=='INNER_BORDER_LINE' || productType=='INNERLINE' ) 
             && packageType=='SUPPLIER'
             && (categoryCode=='category_route_group'|| categoryCode=='category_route_local' ||(categoryCode=='category_route_freedom' && (subCategoryId?? &&subCategoryId!=181)))>   
               <div class="col w120">
                            <label class="radio">
                                <input id="xian{isInput}"  type="radio"  class="JS_radio_switch" name="adultStock" value="INQUIRE_NO_STOCK" data="stockType" onchange='deletePreControlByType($(this))'/>
                                现询
                            </label>
                        </div>
                    </div>
                    
                    <div class="JS_radio_switch_box"  >
                        <div class="col w80"  >
                        	<div class="form-group">
                        	<input class="w40 form-control JS_radio_disabled" disabled type="text"   hidden 
                        	data_name="stockIncrease_{index}" 
                        	data="stock_input"
                        	 data-validate="{regular:true}" 
                        	 data-validate-regular="^\d*$"
                        	 max="999999999"/>
                        	</div>
                        </div>
                    </div>
                    
            <#else>
                        <div class="col w120">
                            <label class="radio">
                                <input id="xian{isInput}"  type="radio"  class="JS_radio_switch" name="adultStock" value="INQUIRE_NO_STOCK" data="stockType" onchange='deletePreControlByType($(this))'/>
                                现询-未知库存
                            </label>
                        </div>
                    </div>
                    <div class="JS_radio_switch_box">
                        <div class="col w120">
                            <label class="radio">
                                <input id="xun{isInput}" type="radio" class="JS_radio_switch" name="adultStock" value="INQUIRE_WITH_STOCK" data="stockType" onchange='deletePreControlByType($(this))'/>
                                现询-已知库存
                            </label>
                        </div>
                        <div class="col w80">
                        	<div class="form-group">
                        	<input class="w40 form-control JS_radio_disabled" disabled type="text" 
                        	data_name="stockIncrease_{index}" 
                        	data="stock_input"
                        	 data-validate="{regular:true}" 
                        	 data-validate-regular="^\d*$"
                        	 max="999999999"/>
                        	</div>
                        </div>
                    </div>
                  </#if>    
                    <div class="JS_radio_switch_box">
                        <div class="col w90">
                            <label class="radio">
                                <input type="radio" class="JS_radio_switch" name="adultStock" value="CONTROL" data="stockType" onchange='deletePreControlByType($(this))'/>
                                切位/库存
                            </label>
                        </div>
                        <div class="col w80">
                        	<div class="form-group">
                        	<input class="w40 form-control JS_radio_disabled" disabled type="text"
                        	 data="stock_input" 
                        	 data-validate="{regular:true}" 
                        	 data-validate-regular="^\d*$"
                        	 max="999999999"/>
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
       
       <!--附加时间模板-->
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
                        	  <#-- <option value="NONE">无限制</option>-->
	                    	   <#--<option value="PREAUTH">一律预授权</option>-->
	                    	   <option value="NOT_PREAUTH">不使用预授权</option>
                        	<#elseif defaultBookLimitType=="NOT_PREAUTH">
                        	   <option value="NOT_PREAUTH">不使用预授权</option>
                        	   <#--<option value="NONE">无限制</option>-->
	                    	   <#--<option value="PREAUTH">一律预授权</option>-->
                        	</#if>
                        </select>
             </div>
		</div>
	  	<div id="multiple_preSale_template_new_preSale">
		 		<div class="row text-gray" data="addpreSaleTag"></div>
		 		<div class="row text-gray W50">[预售]{{}}：</div>
		 	    <div class="col w110 mr10"></div>是否可预售：
		       <input type='radio'  name='bringPreSale{isInput}' value='Y' goodsId='{isInput}' onchange='toIsPreSale($(this))' />是&nbsp;
		       <input type='radio'  name='bringPreSale{isInput}' value='N' goodsId='{isInput}' onchange='toIsPreSale($(this))'  checked />否
		 	<div class="row w550 isPreSaleDiv{isInput}" style="display:none;">
            <div class="col JS_price_group forbidSale">
                <div class="col w110 mr10"></div>
                <div class="col w50">成人价</div>
                <div class="col w150">
                    <div class="form-group">
                        <label>
                                                                                           结算：<input class="w100 form-control JS_price_settlement" data-validate="{regular:true}" 
                          type="text"  data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$"
                          max="999999999" name="auditShowPreSale_pre"  data="auditShowPreSale_pre" data_type="is_input" goods="adult{isInput}" />
                        </label>
                    </div>
                </div>
               </div>
           </div>
          <div class="row w550 isPreSaleDiv{isInput}" style="display:none;">
           <div class="col JS_price_group forbidSale">
           <div class="col w110 mr10"></div>
            <div class="col w50">儿童价</div>
              <div class="col w150">
                 <div class="form-group">
                     <label>
                                                                             结算：<input class="w100 form-control JS_price_settlement"  data-validate="{regular:true}"
                      type="text"  data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" 
                       max="999999999" name="childShowPreSale_pre" data="childShowPreSale_pre"
                       data_type="is_input" goods="child{isInput}"/>
                    </label>
                </div>
             </div>
          </div> 
        </div>
	</div>
</div>

     
<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>

<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/sales-information-single.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script src="/vst_admin/js/js.js" type="text/javascript"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>
<script>
	<#if categoryCode=='category_route_hotelcomb'>
		//将无效的隐藏
		$("label[cancelFlag='Y']").hide();
	</#if>


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
	

var flagReControl=true;

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
var priceType = "";
//商品点击事件
	
	$(".adult_child,.comb_hotel,.addition,.upgrade,.change_hotel").click(function(){
		var that = $(this);
		var name = that.attr("data_name");
		priceType = that.attr("data_price_type");
		var goodsId = that.val();
		var supplierId = that.attr("supplier_id");
		
		//取消勾选商品时候判断是否所有去除,去除则分隔线
		if(that.attr("checked") !='checked'){
			var hideLines = true;			
			$("input[type=checkbox][name=suppGoodsId]").each(function(){
				if($(this).attr("checked") =='checked'){
					hideLines = false;
				}
			})
			if(hideLines){
				$("div[name=isShowLine]").css("display", "none"); 
			}	
		}
		
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
		stockTemplate = stockTemplate.replace(/{isInput}/g,goodsId);

		//设置价格模板
		var priceTemplate = '';
		var prePriceTemlate = '';
		var preSaleTemplate='';
		if(priceType=="SINGLE_PRICE"){
			
			priceTemplate = $("#single_price_template_new").html();
			
			if($(that).attr("class").indexOf("addition")<0){
				prePriceTemlate = $("#pre_single_price_template_new").html();
			}
			
		}else if(priceType=="MULTIPLE_PRICE"){
			priceTemplate = $("#multiple_price_template_new").html();
			prePriceTemlate = $("#pre_multiple_price_template_new").html();
			preSaleTemplate=$("#multiple_preSale_template_new_preSale").html();
		}else {
			alert("该商品未设置价格类型!");
			return;
		}
		if(that.is(".comb_hotel")){
			priceTemplate = priceTemplate.replace(/{isShowOne}/g,"display:none");	
		}else{
			priceTemplate = priceTemplate.replace(/{isShowOne}/g,"");	
		}
		
		//为模板设置商品名称
		priceTemplate = priceTemplate.replace(/{{}}/g,name);
	
		priceTemplate = priceTemplate.replace(/{isInput}/g,goodsId);
		
		priceTemplate = priceTemplate.replace(/{index}/g,globalIndex);	
		
		//买断模板
		prePriceTemlate = prePriceTemlate.replace(/{{}}/g,name);
	
		prePriceTemlate = prePriceTemlate.replace(/{isInput}/g,goodsId);
		
		prePriceTemlate = prePriceTemlate.replace(/{supplierId}/g,supplierId);
		
		prePriceTemlate = prePriceTemlate.replace(/{index}/g,globalIndex);
		
		preSaleTemplate=preSaleTemplate.replace(/{isInput}/g,goodsId);
		preSaleTemplate = preSaleTemplate.replace(/{{}}/g,name);
		
		if(that.attr("data_name")==='自备签'){
			var res = "^-?([1-9]\\d{0,8}|[1-9]\\d{0,8}\\.\\d{1,2}|0\\.\\d{1,2}|0?\\.0{1,2}|0)$"
			priceTemplate = priceTemplate.replace(/{data-validate-regular}/g,res);
		}else{
			priceTemplate = priceTemplate.replace(/{data-validate-regular}/g,"^([1-9]\\d{0,8}|[1-9]\\d{0,8}\\.\\d{1,2}|0\\.\\d{1,2}|0?\\.0{1,2}|0)$");
			prePriceTemlate = prePriceTemlate.replace(/{data-validate-regular}/g,"^([1-9]\\d{0,8}|[1-9]\\d{0,8}\\.\\d{1,2}|0\\.\\d{1,2}|0?\\.0{1,2}|0)$");
		}
		
		
		//设置提前预定时间模板
		var aheadBookTimeTemplate = '';
		aheadBookTimeTemplate +=  $("#ahead_time_template_date_new").html()+"---0ahead0---";
		aheadBookTimeTemplate +=  $("#ahead_time_template_limit_new").html();
		
		//为模板设置商品名称
		aheadBookTimeTemplate = aheadBookTimeTemplate.replace(/{{}}/g,name);

		//设置模板
		setAdultChildTemplate(goodsId,priceTemplate,prePriceTemlate,stockTemplate,aheadBookTimeTemplate,preSaleTemplate);

		globalIndex++;
		if(priceType=="SINGLE_PRICE"){
				//存在一个问题但价格模板添加进来不会触发交互的change时间导致显示模板中的%
				$("div[goodsId="+goodsId+"][data=priceDiv]").find("select").change();
				showCommonTag(divTag,tagName);
		}
        showPreDom1($(":radio[name=isPreControlPrice"+goodsId+"]").eq(1));
		if(that.attr("checked")=='checked'){
			$("div[name=isShowLine]").css("display", "");
			// 设置商品信息
			searchSuppGoodsInfo(goodsId);
	
			$('#scale').val('');
			$('#add').val('');
			$('#pr').val('');
		
		}
		    //------------------------------------------------------------------------------------------------------------------------------------
	 
        
       
        		
	});	
	
	
	//交互动态校验js 由于动态加载html 需要重新load 
	var  validateSingle = null;	
	
	function validInitPrice(){
			var $form = $("#timePriceFormInput");

			//表单验证
			validateSingle = backstage.validate({
			    $area: $form,
			    //$submit: $btnSave,
			    showError: true
			});
			validateSingle.start();
			validateSingle.watch();

	
	}
	
	var isBindFlag = true,showMsg = '';
	// 保存
	$("#singleSave").click(function(){
			//定义校验方法
		 jQuery.validator.addMethod("isNum", function(value, element) {
				    var num = /^[1-9]{0}\d+(\.\d{1,2})?$/;
				    return this.optional(element) || (num.test(value));       
		}, "只能为整数或者最多两位小数");
	
		jQuery.validator.addMethod("isIntegerWith0", function(value, element) {
			var num1 = /^[1-9]{0}\d*$/;
			return this.optional(element) || (num1.test(value));
		}, "只能为整数");	
		
		jQuery.validator.addMethod("isNumber0", function(value, element) {
			var num1 = /^(-)?[1-9]{0}\d+(\.\d{1,2})?$/;
			return this.optional(element) || (num1.test(value));
		}, "只能为数字或者最多两位小数");		
	
		var size = $("input[type=checkbox][name=suppGoodsId]:checked").size();
 		if(size == 0){
 			alert('请选择商品');
 			return;
 		}
 		
 		var priceValidate = $("#timePriceFormInput").validate();
	 	var formValidate =  $("#timePriceForm").validate()
		
	    //清空验证信息
  		formValidate.resetForm();
	  	priceValidate.resetForm();
	  	
		//验证日期
		if(!formValidate.form()){
			return;
		}
	  	//非空判断价格库存
	  	var nullMsg = setValidElementForm();
	  	if(nullMsg!=''){
	  		alert(nullMsg);
	  		return ; 
	  	}
	  	
		//验证必填数据
		if(!priceValidate.form()){
		    return;
		}	
		validInitPrice();
		//前端交互设计价格校验
		if(!validateSingle.getIsValidate()){
			return ;
		}
		
		//判断使用行程
		var lineRouteId = $("select[name=lineRouteId]").val();
		if(lineRouteId == ''){
			alert("请选择适用行程");
			return ;
		}

        //判断跟团游所设儿童价是否小于成人价，房差是否小于等于成人价
        // 自由行所设儿童价是否小于成人价，房差是否小于成人价，一旦超出，则在保存时弹窗警示，但是不做其他限制
        if($("#suppGoodsId_flag").prop("checked")){
            var auditPrice = $("#timePriceFormInput [data='auditPrice']").val();
            var childPrice = $("#timePriceFormInput [data='childPrice']").val();
            var gapPrice = $("#timePriceFormInput [data='gapPrice']").val();
            var thisCategoryId = $("#thisCategoryId").val();
            var flag = true;
            if(thisCategoryId && (thisCategoryId == "15" || thisCategoryId == "18")){
                if(thisCategoryId == "15"){//跟团游
                    if(childPrice && auditPrice && gapPrice){
                        if(childPrice - auditPrice > 0 && gapPrice - auditPrice >= 0){
                            if(!confirm("儿童价大于成人价，房差大于等于成人价！是否继续？")){
                                return;
                            }else{
                                flag = false;//继续
                            };
                        }
                    }
                    if(flag){
                        if(childPrice && auditPrice && childPrice - auditPrice > 0){
                            if(!confirm("儿童价大于成人价！是否继续？")){return;};
                        }
                        if(gapPrice && auditPrice && gapPrice - auditPrice >= 0){
                            if(!confirm("房差大于等于成人价！是否继续？")){return;};
                        }
                    }
                }
                if(thisCategoryId == "18"){//自由行
                    if(childPrice && auditPrice && gapPrice){
                        if(childPrice - auditPrice > 0 && gapPrice - auditPrice >0){
                            if(!confirm("儿童价大于成人价，房差大于成人价！是否继续？")){
                                return;
                            }else{
                                flag = false;//继续
                            };
                        }
                    }
                    if(flag){
                        if(childPrice && auditPrice && childPrice - auditPrice > 0){
                            if(!confirm("儿童价大于成人价！是否继续？")){return;};
                        }
                        if(gapPrice && auditPrice && gapPrice - auditPrice > 0){
                            if(!confirm("设置的房差大于成人价！是否继续？")){return;};
                        }
                    }
                }
            }

        }

		//构造Form提交数据
		$("#timePriceFormContent").empty();
		
		setSelectDate();
		//设置价格表单
	    setPriceFormData();
	    //设置材料截止收取时间
	    var productType="${productType}";
	    var packageType="${packageType}";
	    var categoryCode="${categoryCode}";
	    var suppGoodsId_flag=$("#suppGoodsId_flag").attr("checked");
	    if(suppGoodsId_flag=="checked" && productType=="FOREIGNLINE" && packageType=="SUPPLIER" && (categoryCode=="category_route_group" || categoryCode=="category_route_freedom")){
			if( $("#last_date").val()!=null && $("#last_date").val()!=""){
				setUpDocLastTime();
			}else{
				
			}
		}
	    
	    //设置保存买断价格
	    setPreControlPriceFormData();
	    if(!isBindFlag){
	    	alert("请绑定预控项目");
			return ;
	    }else if(showMsg !=''){
			alert(showMsg);
			return;
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
	    //设置预售
	    setPreSaleIdData();
	    //设置选项
	    setTimeUpdateType();
	    //判断销售价和结算价关系
	
		var res = validatePrice();
		if(res!=""){
			if(!confirm(res+"销售价低于结算价,是否继续")){
				return;
			}
		}
		
		//检查全部禁售		
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
	    
	    //?????
	    $("input[type=checkbox][data=saleAble11]").each(function(){
	        var id = $(this).attr("name");
	        var value = $(this).is(':checked')?"Y":"N";
        	if($("#"+id).val()===""){
        		$("#"+id).val(value);
        	}
	    });
	    
	    //设置产品ID
	    $("#timePriceFormContent").append('<input type="hidden" value="${prodProductId}" name="productId">')
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
		var suppGoodsId = goodsId.substring(claszz.length);
		
		goodsDiv.find("input[type=text]").each(function(){
			var goods = $(this).attr("goods");
		      
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
		});
		
		//点击禁售，disable相应的买断价
		var preGoodsDiv = $("div[goodsid="+suppGoodsId+"][data=pricePreDiv]");
		preGoodsDiv.find("input[type=text]").each(function(){
		var goods = $(this).attr("goods");
		      
				if(that.attr("checked")!='checked' ){
					if(goodsId == goods){
						$(this).removeAttr("disabled");
						preGoodsDiv.find("select").eq(checkIndex).removeAttr("disabled");
					}					
				}else {
					if($(this).attr("goods")==goodsId){
						$(this).attr("disabled","disabled").val("");
						preGoodsDiv.find("select").eq(checkIndex).attr("disabled","disabled");
					}
				}
					
		});
		showPreDom1($(":radio[name=isPreControlPrice"+suppGoodsId+"]:checked"));
		checkboxPreSale(that,suppGoodsId);
	});
	
	//全部禁售绑定事件	
	$("input[type=checkbox][data=saleAbleAll]").live('click',function(){
		var that = $(this);
		var claszz = that.attr("name");
		var goodsId = that.attr("goods");
		var goodsDiv = that.parents("div[goodsId]");
		var suppGoodsId = goodsId;
		
		if(that.attr("checked")!="checked"){
			$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=text][data_type=is_input]").each(function(){
				$(this).removeAttr("disabled");
				goodsDiv.find("select").removeAttr("disabled");
				goodsDiv.find(":checkbox").removeAttr("checked");
			});
		}else{
			$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=text][data_type=is_input]").each(function(){
				$(this).attr("disabled","disabled").val("");
				<!--$(this).val("");-->
				goodsDiv.find(":checkbox").attr("checked",true);
				goodsDiv.find("select").attr("disabled","disabled");
			});
			
		}
		
		var preGoodsDiv = $("div[goodsid="+suppGoodsId+"][data=pricePreDiv]");
		
			if(that.attr("checked")!="checked"){
		    preGoodsDiv.find("input[type=text]").each(function(){
				$(this).removeAttr("disabled");
				preGoodsDiv.find("select").removeAttr("disabled");
				preGoodsDiv.find(":checkbox").removeAttr("checked");
			});
		}else{
			  preGoodsDiv.find("input[type=text]").each(function(){
				$(this).attr("disabled","disabled");
				<!--$(this).val("");-->
				preGoodsDiv.find("select").attr("disabled","disabled");
			});
			
		}
		

		
		
		
	 showPreDom1($(":radio[name=isPreControlPrice"+suppGoodsId+"]:checked"));
	 	checkboxPreSale(that,suppGoodsId);		
		
	});
	
	
	//取消关闭按钮
	$("#singleCancel").live('click',function(){
		//window.parent.document.getElementById('search_button').click();
        window.parent.batchProdRouteDialog.close();
		
	})
	
	//库存选择按钮绑定清空库存时间
	//$("input[type=radio][data=stockType]").live("click",clearStock)
	
 function checkboxPreSale(obj,suppGoodsId){
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
     $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+suppGoodsId+"']").removeAttr("disabled","disabled");
	  $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+suppGoodsId+"']").removeAttr("disabled","disabled");

   
    if(allFlag&&adultFlag&&childFlag&&gapFlag){
	      $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+suppGoodsId+"']").attr("disabled","disabled");
		  $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+suppGoodsId+"']").val("");
		  $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+suppGoodsId+"']").attr("disabled","disabled");
		  $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+suppGoodsId+"']").val("");
    }else if(adultFlag&&!allFlag&&!childFlag&&!gapFlag){
	     $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+suppGoodsId+"']").attr("disabled","disabled");
		 $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+suppGoodsId+"']").val("");
    }else if(childFlag&&!adultFlag&&!gapFlag&&!allFlag){
	     $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+suppGoodsId+"']").attr("disabled","disabled");
		 $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+suppGoodsId+"']").val("");
    }else if(adultFlag&&childFlag&&!gapFlag&&!allFlag){
	     $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+suppGoodsId+"']").attr("disabled","disabled");
		 $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+suppGoodsId+"']").val("");
		 $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+suppGoodsId+"']").attr("disabled","disabled");
		 $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+suppGoodsId+"']").val("");
    }else if(gapFlag&&adultFlag&&childFlag&&!allFlag){
         $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+suppGoodsId+"']").attr("disabled","disabled");
		 $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+suppGoodsId+"']").val("");
		 $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+suppGoodsId+"']").attr("disabled","disabled");
		 $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+suppGoodsId+"']").val("");
    }else if(gapFlag&&adultFlag&&!childFlag&&!allFlag){
	     $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+suppGoodsId+"']").attr("disabled","disabled");
		 $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='auditShowPreSale_pre'][goods='adult"+suppGoodsId+"']").val("");
    }else if(gapFlag&&!adultFlag&&childFlag&&!allFlag){
	     $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+suppGoodsId+"']").attr("disabled","disabled");
		 $("div[goodsId="+suppGoodsId+"][data=onePreSaleDiv]").find("input[name='childShowPreSale_pre'][goods='child"+suppGoodsId+"']").val("");
    }
   }
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
		var selectCalendar = $('#spec_date').val();
        $("#selectDates_low").val(selectCalendar);
		$("#timePriceFormContent").append('<input type="hidden" name="selectDates" value="'+selectCalendar+'">');
		$("#timePriceFormContent").append('<input type="hidden" name="selectCalendar" value="selectDate">');
		
	}
	function setUpDocLastTime(){
		var selectCalendar = $('#spec_date').val();
		var lastDate = $('#last_date').val();
		$("#timePriceFormContent").append('<input type="hidden" name="upDocLastTime" id="upDocLastTime" value="'+selectCalendar+'|'+lastDate+'">');
	}
	//设置价格表单数据
	function setPriceFormData(){
		var t = 0 ; 
		$("div[data='priceDiv']").each(function(i){
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
				    			//clone.val(parseInt(clone.val()*100,0));
				    			inputValue = parseInt(clone.val()*100,0);
				    		}else if(decimallen == 1){
				    			//clone.val(clone.val().replace(".","")+"0");
				    			inputValue = clone.val().replace(".","")+"0";
				    			
				    		}else if(decimallen == 2){
				    			//clone.val(clone.val().replace(".",""));
				    			inputValue = clone.val().replace(".","");
				    		}
				    		inputValue = parseInt(inputValue);
				    		clone.removeAttr('disabled');
				    		//$("#timePriceFormContent").append(clone);
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
				that.find("input[data=saleAbleAll]").each(function(){
						if($(this).attr("checked")=='checked'){
							onsaleFlag = 'N';
						}
				});
	
		    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].onsaleFlag" value="'+onsaleFlag+'">');
		    	t++;
	    	
	    	}
	    	
	    });
	}

	//设置库存表单数据
	function setStockFormData(){
		var t = 0 ; 
		$("div[data='stockDiv']").each(function(i){
	    	var that = $(this);
	    	if(that.html()!='undefined' && $.trim(that.html())!=''){
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
	        //------------------------------------------------------------------------------------------------------------------------------------
	
       
	    
	}
	//$("#aheadBookTime_set").find("div[goodsId="+goodsId+"][data='timeDiv_date']");
	//设置提前预定时间表单数据
	function setAheadBookTimeFormData(){
		var t = 0 ; 
		$("#timePriceFormInput").find("div[data='timeDiv_date']").each(function(i){
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
		$("div[data='timeDiv_limit']").each(function(i){
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
	//设置预售
	function setPreSaleIdData(){
	     var t = 0 ; 
	   $('#timePriceFormInput').siblings("div.row").find("input[type='checkbox']").each(function(i){
	    var that = $(this);
	     var PreSale=that.parents('div.row').siblings('#timePriceFormInput').find('#price_set_pre').find('div[data=onePreSaleDiv][goodsId='+$(this).attr('value')+']');
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
	<!--设置适用行程-->
	function setLineRouteIdData(){
		var lineRouteId = $("select[name=lineRouteId]").val();
		$("#timePriceFormContent").append('<input type="hidden" name="lineRouteId" value="'+lineRouteId+'">');		
	}
	
	
	var lowPriceDialog;
	 //低毛利率
    function submitLowPrice(){
        $.ajax({
            url : '/vst_admin/goods/grossMargin/saveGrossMarginLogs.do',
            method: 'POST',
            data : $("#lowPriceForm,#timePriceForm").serialize(),
            async : false,
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
						var infoMsg = '';
						if(result.attributes){
							if(result.attributes.infoMsg){
								infoMsg = result.attributes.infoMsg;
							}
						}
						saveSuccess("保存成功!"+infoMsg);
					}else{
						saveSuccess('保存失败');
					}
				
				},
				error : function(){
					saveSuccess('服务器错误');
					loading.close();
				}
    	})
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
		//适用用行程默认请选择
		$("input[type=hidden][name=lineRouteIdBack]").val($("select[name=lineRouteId]").val());
		$("select[name=lineRouteId]").val('');
				
		$("div[name=isShowLine]").css("display", "none"); 
    }
    
    function saveSuccess(content){
    	backstage.alert({
    		content: content
		});
    }
	

	
	//验证销售价和结算价关系
	function validatePrice(){
		var result = "";
		var index = 0;
		//判断成人儿童方差find("div[data='timeDiv_date']")
		$("div[divTag='adult_child_diff']").each(function(i){
			
            var that = $(this);
            if(that.html()!='undefined' && $.trim(that.html())!='' ){
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
        
        $("div[divTag='combo_dinner']").each(function(i){
        	//酒店套餐
        	 var that = $(this);

            if(that.html()!='undefined' && $.trim(that.html())!='' ){
	            var auditSettlementPriceVal_hotel = that.find("input[data=auditSettlementPrice]").val();
	            var auditPriceVal_hotel = that.find("input[data=auditPrice]").val();
	            if(auditSettlementPriceVal_hotel!=null && (parseFloat(auditSettlementPriceVal_hotel) > parseFloat(auditPriceVal_hotel))){
	                result = "套餐 ";
	                return false;
	            }
        	}
        })
		//判断附加
        $("div[divTag='addition']").each(function(i){
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
		 $("div[divTag='upgrad']").each(function(i){
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
        $("div[divTag='changed_hotel']").each(function(i){
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
	

//根据商品获取其价格库存、提前预定时间等信息
	function searchSuppGoodsInfo(goodsId){
		var spec_date = $('#spec_date').val();
		url = "/vst_admin/lineMultiroute/goods/timePrice/findSuppGoodsInfoByIdAndSpecDate.do";
		$.ajax({
            url: url,
            type: "POST",
            dataType: "JSON",
            data : {'suppGoodsId':goodsId,'specDate':spec_date},
            success: function (json) {
               setData(json);
               if(flagReControl==true){
               	if($(".addition").is(':checked')||$(".upgrade").is(':checked')||$(".change_hotel").is(':checked')){
			    }else{
		         showPreDom($(":radio[name=isPreControlPrice"+goodsId+"]").eq(1));
		        }	
               }
     
            },
            error: function () { }
        });		
		
		function setData(data){
			data.forEach(function (arr) {
				var goodsId = arr.suppGoodsId;
				
				// 设置成人价格
				var auditSettlementPrice = arr.auditSettlementPrice;
				var auditPrice = arr.auditPrice;	
				var onsaleFlag = arr.onsaleFlag;
				if(onsaleFlag=="N"){
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=checkbox][goods="+goodsId+"]").attr('checked',true);
				}
				
				
				if(auditSettlementPrice==null){
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=auditSettlementPrice]").attr("disabled","disabled");
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=auditPrice]").attr("disabled","disabled");
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=checkbox][goods=adult"+goodsId+"]").attr('checked',true);
					$("div[goodsid="+goodsId+"][data='onePreSaleDiv']").find("input[name='auditShowPreSale_pre'][goods='adult"+goodsId+"']").attr("disabled","disabled");
				}else if(auditSettlementPrice!=null && onsaleFlag=="N"){
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=auditSettlementPrice]").attr("disabled","disabled");
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=auditPrice]").attr("disabled","disabled");
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=checkbox][goods=adult"+goodsId+"]").attr('checked',true);
					$("div[goodsid="+goodsId+"][data='onePreSaleDiv']").find("input[name='auditShowPreSale_pre'][goods='adult"+goodsId+"']").attr("disabled","disabled");
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=auditSettlementPrice]").val((auditSettlementPrice/100).toFixed(2));
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=auditPrice]").val((auditPrice/100).toFixed(2));
				}else{
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=auditSettlementPrice]").removeAttr('disabled');
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=auditPrice]").removeAttr('disabled');
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=checkbox][goods=adult"+goodsId+"]").removeAttr('checked');
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=auditSettlementPrice]").val((auditSettlementPrice/100).toFixed(2));
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=auditPrice]").val((auditPrice/100).toFixed(2));
					$("div[goodsid="+goodsId+"][data='onePreSaleDiv']").find("input[name='auditShowPreSale_pre'][goods='adult"+goodsId+"']").removeAttr("disabled","disabled");
					
				}
				
				<#if categoryCode=='category_route_hotelcomb'>
					//售卖标志，N为禁售，Y为可售
            		var onsaleFlag = arr.onsaleFlag;
            		if(onsaleFlag=="N"){
            			$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=auditSettlementPrice]").attr("disabled","disabled");
						$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=auditPrice]").attr("disabled","disabled");
						$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=checkbox][goods=adult"+goodsId+"]").attr('checked',true);		
            		}
				</#if>
				// 设置儿童价格
				var childSettlementPrice = arr.childSettlementPrice;
				var childPrice = arr.childPrice;	
				if(childSettlementPrice==null){
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=childSettlementPrice]").attr("disabled","disabled");
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=childPrice]").attr("disabled","disabled");
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=checkbox][goods=child"+goodsId+"]").attr('checked',true);
					$("div[goodsid="+goodsId+"][data='onePreSaleDiv']").find("input[name='childShowPreSale_pre'][goods='child"+goodsId+"']").attr("disabled","disabled");			
				}else if(childSettlementPrice!=null && onsaleFlag=="N"){
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=childSettlementPrice]").attr("disabled","disabled");
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=childPrice]").attr("disabled","disabled");
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=checkbox][goods=child"+goodsId+"]").attr('checked',true);
					$("div[goodsid="+goodsId+"][data='onePreSaleDiv']").find("input[name='childShowPreSale_pre'][goods='child"+goodsId+"']").attr("disabled","disabled");
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=childSettlementPrice]").val((childSettlementPrice/100).toFixed(2));
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=childPrice]").val((childPrice/100).toFixed(2));			
				}else{	
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=childSettlementPrice]").removeAttr('disabled');
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=childPrice]").removeAttr('disabled');
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=checkbox][goods=child"+goodsId+"]").removeAttr('checked');
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=childSettlementPrice]").val((childSettlementPrice/100).toFixed(2));
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=childPrice]").val((childPrice/100).toFixed(2));
					$("div[goodsid="+goodsId+"][data='onePreSaleDiv']").find("input[name='childShowPreSale_pre'][goods='child"+goodsId+"']").removeAttr("disabled","disabled");	
				}		
				
				if(arr.bringPreSale=='Y'){
					$("div[data=onePreSaleDiv][goodsid="+goodsId+"]").find("input[type='radio']").eq(0).attr("checked","checked");
					$("div[data=onePreSaleDiv][goodsid="+goodsId+"]").find("div.isPreSaleDiv"+goodsId).show();
					$("div[data=onePreSaleDiv][goodsid="+goodsId+"]").find("div.isPreSaleDiv"+goodsId).find("input[name='auditShowPreSale_pre'][goods=adult"+goodsId+"]").val(arr.auditShowPreSale_pre==0?'':(arr.auditShowPreSale_pre/100).toFixed(2));
					$("div[data=onePreSaleDiv][goodsid="+goodsId+"]").find("div.isPreSaleDiv"+goodsId).find("input[name='childShowPreSale_pre'][goods=child"+goodsId+"]").val(arr.childShowPreSale_pre==0?'':(arr.childShowPreSale_pre/100).toFixed(2));
				if(arr.auditIsBanSell=='Y'){
					$("div[data=onePreSaleDiv][goodsid="+goodsId+"]").find("div.isPreSaleDiv"+goodsId).find("input[name='auditShowPreSale_pre'][goods=adult"+goodsId+"]").attr("disabled","disabled");
				}
				if(arr.childIsBanSell=='Y'){
					$("div[data=onePreSaleDiv][goodsid="+goodsId+"]").find("div.isPreSaleDiv"+goodsId).find("input[name='childShowPreSale_pre'][goods=child"+goodsId+"]").attr("disabled","disabled");
				}
				}else{
					$("div[data=onePreSaleDiv][goodsid="+goodsId+"]").find("input[type='radio']").eq(1).attr("checked","checked");
					$("div[data=onePreSaleDiv][goodsid="+goodsId+"]").find("div.isPreSaleDiv"+goodsId).hide();
					$("div[data=onePreSaleDiv][goodsid="+goodsId+"]").find("div.isPreSaleDiv"+goodsId).find("input[name='childShowPreSale_pre'][goods=child"+goodsId+"]").val("");
					$("div[data=onePreSaleDiv][goodsid="+goodsId+"]").find("div.isPreSaleDiv"+goodsId).find("input[name='auditShowPreSale_pre'][goods=adult"+goodsId+"]").val("");
				if(arr.auditIsBanSell=='Y'){
					$("div[data=onePreSaleDiv][goodsid="+goodsId+"]").find("div.isPreSaleDiv"+goodsId).find("input[name='auditShowPreSale_pre'][goods=adult"+goodsId+"]").attr("disabled","disabled");
				}
				if(arr.childIsBanSell=='Y'){
					$("div[data=onePreSaleDiv][goodsid="+goodsId+"]").find("div.isPreSaleDiv"+goodsId).find("input[name='childShowPreSale_pre'][goods=child"+goodsId+"]").attr("disabled","disabled");
				}
				}
				// 设置房差价格
				var grapSettlementPrice = arr.grapSettlementPrice;
				var gapPrice = arr.gapPrice;	
				if(grapSettlementPrice==null){
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=grapSettlementPrice]").attr("disabled","disabled");
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=gapPrice]").attr("disabled","disabled");
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=checkbox][goods=gap"+goodsId+"]").attr('checked',true);
				}else if(grapSettlementPrice!=null&&onsaleFlag=="N"){
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=grapSettlementPrice]").attr("disabled","disabled");
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=gapPrice]").attr("disabled","disabled");
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=checkbox][goods=gap"+goodsId+"]").attr('checked',true);
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=grapSettlementPrice]").val((grapSettlementPrice/100).toFixed(2));	
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=gapPrice]").val((gapPrice/100).toFixed(2));
				}else{
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=grapSettlementPrice]").removeAttr('disabled');
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=gapPrice]").removeAttr('disabled');
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=checkbox][goods=gap"+goodsId+"]").removeAttr('checked');		
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=grapSettlementPrice]").val((grapSettlementPrice/100).toFixed(2));	
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[data=gapPrice]").val((gapPrice/100).toFixed(2));	
				}
				 
				/*
				if($("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=checkbox][goods=adult"+goodsId+"]").attr('checked')!='checked'){
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=checkbox][goods=gap"+goodsId+"]").removeAttr('disabled');
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=checkbox][goods=child"+goodsId+"]").removeAttr('disabled');
				}else{
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=checkbox][goods=gap"+goodsId+"]").attr('disabled',"disabled");
					$("div[data=priceDiv][goodsId="+goodsId+"]").find("input[type=checkbox][goods=child"+goodsId+"]").attr('disabled',"disabled");
				}*/		
				//页面  
				//------------------------------------------------------
				
				
				//设置买duan
			
				var rePreSaleFlag = arr.preSaleFlag;
				
				 
				var preSaleFlagRadios = $(":radio[name=useBudgePrice"+goodsId+"]");
				var perYuKongRadios=$(":radio[name=isPreControlPrice"+goodsId+"]");

				
				var obj = $("#isPreControlPrice"+goodsId);
				//是否启用买断价
				if(arr.isPreControl=='N'||arr.isPreControl==null){
				    perYuKongRadios.eq(0).removeAttr("checked");
					perYuKongRadios.eq(1).attr("checked","checked");
					showPreDom1(perYuKongRadios.eq(1));
				}else{
				    perYuKongRadios.eq(1).removeAttr("checked");
					perYuKongRadios.eq(0).attr("checked","checked");
					showPreDom1(perYuKongRadios.eq(0));
					//赋值买断预控项目
					var resPrecontrolPolicies = arr.resPrecontrolPolicies;
				   	var resPrecontrolIdArray = new Array();
				   	var resPrecontrolNameArray = new Array();
					if(resPrecontrolPolicies != null){
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
					
					if(rePreSaleFlag == "Y"){
					    preSaleFlagRadios.eq(1).removeAttr("checked");
						preSaleFlagRadios.eq(0).attr("checked","checked");
						showPreControl(preSaleFlagRadios.eq(0));
					}else{
						preSaleFlagRadios.eq(0).removeAttr("checked");
						preSaleFlagRadios.eq(1).attr("checked","checked");
						showPreControl(preSaleFlagRadios.eq(1));
					}
					
					var thisPriceDIV = $("div[goodsid="+goodsId+"]","#price_set_pre");
					// 设置成人价格
					var auditSettlementPrice_pre = arr.auditSettlementPrice_pre;
					var auditPrice_pre = arr.auditPrice_pre;	
					if(auditSettlementPrice_pre==null){
						$('#adultSettlePrice_pre_'+goodsId).attr("disabled","disabled");
					    $('#adultPrice_pre_'+goodsId).attr("disabled","disabled");
					}else{
						$('#adultSettlePrice_pre_'+goodsId).removeAttr("readonly").val((auditSettlementPrice_pre/100).toFixed(2));
						$('#adultPrice_pre_'+goodsId).removeAttr("readonly").val((auditPrice_pre/100).toFixed(2));					
					}
						
					// 设置儿童价格
					var childSettlementPrice_pre = arr.childSettlementPrice_pre;
					var childPrice_pre = arr.childPrice_pre;	
					if(childSettlementPrice_pre==null){
						var jsCheckBoxes = $(":checkbox[class*=JS_checkbox_lock_item]",thisPriceDIV);
						if(jsCheckBoxes.length > 1){
							jsCheckBoxes.eq(1).trigger("click");
							priceLockHandler.call(jsCheckBoxes.eq(1));
							jsCheckBoxes.eq(1).attr('checked','checked');
						}
						$('#childSettlePrice_pre_'+goodsId).removeAttr("readonly").attr("disabled","disabled");
						$('#childPrice_pre_'+goodsId).removeAttr("readonly").attr("disabled","disabled");	
					}else{
						$('#childSettlePrice_pre_'+goodsId).removeAttr("readonly").val((childSettlementPrice_pre/100).toFixed(2));
						$('#childPrice_pre_'+goodsId).removeAttr("readonly").val((childPrice_pre/100).toFixed(2));	
						$(":checkbox[class*=JS_checkbox_lock_item]",thisPriceDIV).eq(1).removeAttr('checked').removeAttr("disabled");
						$("select",thisPriceDIV).eq(1).removeAttr("disabled");
					}
						
				}
				
			    
		
				
			  	if($(".addition").is(':checked')||$(".upgrade").is(':checked')||$(".change_hotel").is(':checked')){
			    }else{
		         	flagReControl=false;
		        }		
				//-----------------------------------------
				// 设置库存stockDiv
				var stockType = arr.stockType;
				var stock = arr.stock;
				var oversell_flag = arr.oversellFlag;
				$("div[data=stockDiv][goodsId="+goodsId+"]").find("input[type=radio][data=stockType][value="+stockType+"]").attr("checked",true); 
				$('#'+stockType+globalIndex).attr('checked','true');
				if(stockType=='INQUIRE_WITH_STOCK'){
					
					var obj = $("div[data=stockDiv][goodsId="+goodsId+"]").find("input[type=text]").eq(0);
					obj.removeAttr('disabled');
					obj.val(stock);
					// 设置是否超卖
					$("div[data=stockDiv][goodsId="+goodsId+"]").find('input[type=radio][data=oversellFlag][value='+oversell_flag+']').attr('checked','true');
				}else if(stockType=='CONTROL'){
					var obj = $("div[data=stockDiv][goodsId="+goodsId+"]").find("input[type=text]").eq(1);;
					obj.removeAttr('disabled');
					obj.val(stock);
					// 设置是否超卖
					$("div[data=stockDiv][goodsId="+goodsId+"]").find('input[type=radio][data=oversellFlag][value='+oversell_flag+']').attr('checked','true');		
				}
				//判断
	          	var xian="xian"+goodsId;
				
				var xun="xun"+goodsId;
				
			   	if($('#'+xian).is(":checked")){
			   		deletePreControlByType($('#'+xian));
			   	}
			   	if($('#'+xun).is(":checked")){
			   		deletePreControlByType($('#'+xun));
			   	}
				
				// 设置提前预定时间
				var aheadBookTime = arr.aheadBookTime;
				var bookLimitType = arr.bookLimitType;
				minutesToDate(aheadBookTime,bookLimitType);
				
				//设置行程
				var routeId = $("input[type=hidden][name=lineRouteIdBack]").val();
				if(routeId!=''){
					$("select[name=lineRouteId]").val(routeId);
				}	
			});
			globalIndex++;
		}
		
		//将分钟数转换为天/时/分
        function minutesToDate(time,bookLimitType){
        	var time = parseInt(time);
			var day=0;
			var hour=0;
			var minute=0;
			if(time >  0){
				day = Math.ceil(time/1440);
				if(time%1440==0){
					hour = 0;
					minute = 0;
				}else {
					hour = parseInt((1440 - time%1440)/60);
					minute = parseInt((1440 - time%1440)%60);
				}
				
			}else if(time < 0 ){
				time = -time;
				hour = parseInt(time/60);
				minute = parseInt(time%60);
			}
			$("div[data=timeDiv_date][goodsId="+goodsId+"]").find("select[name=aheadBookTime_day]").eq(0).find("option[value='"+day+"']").attr("selected",true);
			$("div[data=timeDiv_date][goodsId="+goodsId+"]").find("select[name=aheadBookTime_hour]").eq(0).find("option[value='"+hour+"']").attr("selected",true);
			$("div[data=timeDiv_date][goodsId="+goodsId+"]").find("select[name=aheadBookTime_minute]").eq(0).find("option[value='"+minute+"']").attr("selected",true);
			$("div[data=timeDiv_limit][goodsId="+goodsId+"]").find("select[name=bookLimitType]").eq(0).find("option[value='"+bookLimitType+"']").eq(0).attr("selected",true);

        }
	}
	
//设置选项
	function setTimeUpdateType(){
		if($("#isSetPrice").attr("checked")=="checked"){
	    	$("input[name=isSetPrice]").val("Y");
	    }else {
	    	$("input[name=isSetPrice]").val("N");
	    }
	    if($("#isSetStock").attr("checked")=="checked"){
	    	$("input[name=isSetStock]").val("Y");
	    }else {
	    	$("input[name=isSetStock]").val("N");
	    }
	    if($("#isSetAheadBookTime").attr("checked")=="checked"){
	    	$("input[name=isSetAheadBookTime]").val("Y");
	    }else {
	    	$("input[name=isSetAheadBookTime]").val("N");
	    }
	}
	
	//显示单价格模板标示 如附加 套餐 等
	function showCommonTag(divTag,tagName){
			var tag = true;
			$("#timePriceFormInput").find("div[divTag="+divTag+"]").each(function(){
				var that = $(this);
				
				if(that.html()!='undefined' && $.trim(that.html())!=''){
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
	   	$("div[data='priceDiv']").each(function(){
	   		var that = $(this);
	   		var size = that.find("input[type=text][data_type=is_input][disabled!=disabled]").size();
	   					
			that.find("input[type=text][data_type=is_input][disabled!=disabled]").each(function(){
				var oV = $(this).val();
				if(oV=="undefined" || oV==null || $.trim(oV)==""){
		    		nullMsg =  "价格不能为空！";
		    		return false;
		    	}
				/*
				if($(this).attr("notnumber")!="Y"){
					$(this).rules("add",{required : true, number : true,isNum:true , min : 0,messages : {min:'价格必须大于等于0',isNum:'价格格式不正确(填至多2位小数正数)'}});
    			}
				*/
			});

			if(nullMsg!=""){
				return false;
			}
		
		});
		$("div[data='pricePreDiv']").each(function(){
	   		var that = $(this);
	   		var size = that.find("input[type=text][data_type=is_input][disabled!=disabled]").size();
	   					
			that.find("input[type=text][data_type=is_input][disabled!=disabled]").each(function(){
				var oV = $(this).val();
				if(oV=="undefined" || oV==null || $.trim(oV)==""){
		    		nullMsg =  "价格不能为空！";
		    		return false;
		    	}

			});
			if(nullMsg!=""){
				return false;
			}
		
		});
		if(nullMsg!=""){
			return nullMsg;
		}
		
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

	    //提前预定时间校验
	    $("#timePriceFormInput").find("div[data='timeDiv_date']").each(function(i){
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
		
	    $("#timePriceFormInput").find("div[data='timeDiv_limit']").each(function(i){
		    var that = $(this);
		    if($.trim(that.html())!=''){
			   
				var bookLimitType = that.find("select[name=bookLimitType]").val();
				if(bookLimitType == ""){
					nullMsg = "预付预授权限制不能为空";
					return false ; 
				}
			    
			}    
	    });
	    
	    $("#timePriceFormInput").find("div[data='onePreSaleDiv']").each(function(i){
		    var that = $(this);
		    var bringPreSale = that.find("input[type=radio][name^=bringPreSale]:checked").val();
			if(bringPreSale == 'Y') {
				that.find("input[type=text][data_type=is_input][disabled!=disabled]").each(function(){
					var oV = $(this).val();
					if(oV=="undefined" || oV==null || $.trim(oV)==""){
				    	nullMsg =  "预售价格不能为空！";
				    	return false;
				    }
		
				});
				if(nullMsg!=""){
					return false;
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
	//设置模板
	function setAdultChildTemplate(goodsId,priceTemplate,prePriceTemplate,stockTemplate,aheadBookTimeTemplate,preSaleTemplate){
		//设置价格模板
		var priceTemplates = $("div[goodsId="+goodsId+"][data='priceDiv']");
		priceTemplates.append(priceTemplate);
		priceTemplates.show();
		if($(".addition").is(':checked')||$(".upgrade").is(':checked')||$(".change_hotel").is(':checked')){
		
		}else{
		//设置价格模板
		var prePriceTemplates = $("div[goodsId="+goodsId+"][data='pricePreDiv']");
		prePriceTemplates.append(prePriceTemplate);
		
		prePriceTemplates.show();
		}
		

		//设置库存模板
		var stockTemplates = $("div[goodsId="+goodsId+"][data='stockDiv']");
		stockTemplates.append(stockTemplate);
		stockTemplates.show();
		//设置提前预定时间模板
		
		var aheadBookTimeTemplate_date = aheadBookTimeTemplate.split("---0ahead0---")[0];
		var aheadBookTimeTemplate_limit = aheadBookTimeTemplate.split("---0ahead0---")[1];
		var timeDiv_dateTemplates = $("div[goodsId="+goodsId+"][data='timeDiv_date']");
		timeDiv_dateTemplates.append(aheadBookTimeTemplate_date);
		
		var timeDiv_limitTemplates = $("div[goodsId="+goodsId+"][data='timeDiv_limit']");
		timeDiv_limitTemplates.append(aheadBookTimeTemplate_limit);
		timeDiv_dateTemplates.show();
		timeDiv_limitTemplates.show();
		
		validInitPrice();
		//预售价格设置
		 var onepreSaleTemp= $("div[goodsId="+goodsId+"][data='onePreSaleDiv']");
	     onepreSaleTemp.append(preSaleTemplate);
		 onepreSaleTemp.show();
		
		
		
	}
	
  	//是否显示买断预控
	function showPreDom1(obj){
	  	var goodsId = obj.attr('goodsId');
	  	var preDivClass = 'useMaiDuan'+goodsId;
	    var auditSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='auditSettlementPrice_pre']");
	    var childSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='childSettlementPrice_pre']");
	    var auditPrice_pre = $("."+preDivClass).find("input[type=text][name='auditPrice_pre']");
	    var childPrice_pre = $("."+preDivClass).find("input[type=text][name='childPrice_pre']");
	    var goodsArray=''+goodsId;
		if(obj.val()=='Y'){
		    $("."+preDivClass).show(); 
		    $(".bindControlProject"+goodsId).show();
		    auditSettlementPrice_pre.removeAttr("disabled");
			childSettlementPrice_pre.removeAttr("disabled");			
			auditPrice_pre.removeAttr("disabled");		
			childPrice_pre.removeAttr("disabled");
			showPreControl($(":radio[name=isPreControlPrice"+goodsId+"]").eq(1));
		}else{
	  		$("."+preDivClass).hide();
	  		$(".bindControlProject"+goodsId).hide();
		  	auditSettlementPrice_pre.attr("disabled","disabled");			
		  	childSettlementPrice_pre.attr("disabled","disabled");
		  	auditPrice_pre.attr("disabled","disabled");			
		  	childPrice_pre.attr("disabled","disabled");
		  	//当商品禁止预控的时候，买断价，也要设置为不启用
			var preSaleFlagRadios = $(":radio[name=useBudgePrice"+goodsId+"]");
			preSaleFlagRadios.eq(0).removeAttr("checked");
			preSaleFlagRadios.eq(1).attr("checked","checked");
		}
	}
	
	//是否显示买断预控
	function showPreDom(obj){
	 	var goodsId = obj.attr('goodsId');
	  	var preDivClass = 'useMaiDuan'+goodsId;
	   	var auditSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='auditSettlementPrice_pre']");
	   	var childSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='childSettlementPrice_pre']");
	   	var auditPrice_pre = $("."+preDivClass).find("input[type=text][name='auditPrice_pre']");
	   	var childPrice_pre = $("."+preDivClass).find("input[type=text][name='childPrice_pre']");
	   	var goodsArray=''+goodsId;
		if(obj.val()=='Y'){
		    $("."+preDivClass).show(); 
		    $(".bindControlProject"+goodsId).show();
		    
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
		}else{
		  	$("."+preDivClass).hide();
		  	$(".bindControlProject"+goodsId).hide();
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
			flagReControl=true;
		}
	}
	
	//是否启用买断价
	function showPreControl(obj){

	   var goodsId = obj.attr('goodsId');
	   var preDivClass = 'useMaiDuan'+goodsId;
	   var auditSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='auditSettlementPrice_pre']");
	   var childSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='childSettlementPrice_pre']");
	   var auditPrice_pre = $("."+preDivClass).find("input[type=text][name='auditPrice_pre']");
	   var childPrice_pre = $("."+preDivClass).find("input[type=text][name='childPrice_pre']");
		if(obj.val()=='Y'){
		    $("."+preDivClass).show(); 
		    if($("#adult1").is(":checked")||$("#adult2").is(":checked")){

		    }else{
			    auditSettlementPrice_pre.removeAttr("disabled").val("");
			    auditPrice_pre.removeAttr("disabled").val("");	
		    }
		    if($("#child1").is(":checked")){

			}else{
				childSettlementPrice_pre.removeAttr("disabled").val("");			
				childPrice_pre.removeAttr("disabled").val("");
			}
			//跟团游、周边游露出价格同步按钮
			<#if categoryCode=='category_route_group' || categoryCode=='category_route_local'>
				$("#syncPrice").css("display","inline-block");
			</#if>
			
		}else{
		  $("."+preDivClass).hide();
		  auditSettlementPrice_pre.attr("disabled","disabled");	
		  childSettlementPrice_pre.attr("disabled","disabled");
		  auditPrice_pre.attr("disabled","disabled");			
		  childPrice_pre.attr("disabled","disabled");
		  $("div[div=useMaiDuan"+goodsId+"]").show();
		  //跟团游、周边游隐藏价格同步按钮
		  <#if categoryCode=='category_route_group' || categoryCode=='category_route_local'>
		  	$("#syncPrice").css("display","none");
		  </#if>
		}
		
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
	    var preDivClass = 'useMaiDuan'+goodsId;
	
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
	
		if(goodPriceType=="MULTIPLE_PRICE"){//多价格模板才有儿童价格模板
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
	
	
	//预控买断价格表单数据设置
	function setPreControlPriceFormData(){	
	    var i = 0 ; 
		$("#price_set_pre").find("div[data='pricePreDiv']").each(function(){
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
	    	//showPreDom($(":radio[name=isPreControlPrice"+goodsId+"]").eq(1));
	    });
	}
	
	 //设置是否预售
  function toIsPreSale(obj){
     var parentDiv = obj.parents('div[data="onePreSaleDiv"]');
	 var goodsId = parentDiv.attr('goodsid');
	 var val = obj.val();
	 if(val=='Y'){
	 $('div.isPreSaleDiv'+goodsId).show();
	 }else{
	  $('div.isPreSaleDiv'+goodsId).hide();
	 }
  }
//根据库存类型判断是否删除对应的买断设置
	function deletePreControlByType(obj){
		 var parentDiv = obj.parents('div[data="stockDiv"]');
		 var goodsId = parentDiv.attr('goodsid');
		 var val = obj.val();
		 var preDiv = $("#price_set_pre").find('div[goodsid='+goodsId+']');
	   var goodsId =  parentDiv.attr('goodsid');
	   var preDivClass = 'useMaiDuan'+goodsId;
	   var auditSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='auditSettlementPrice_pre']");
	   var childSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='childSettlementPrice_pre']");
	   var auditPrice_pre = $("."+preDivClass).find("input[type=text][name='auditPrice_pre']");
	   var childPrice_pre = $("."+preDivClass).find("input[type=text][name='childPrice_pre']");
		 //现询
		 if(val=='INQUIRE_WITH_STOCK' ||val=='INQUIRE_NO_STOCK')
		 {
		    $("#price_set_pre").find("div[div='useBind"+goodsId+"']").show();
		    var useBudgeDiv = $("#price_set_pre").find("div[div='useMaiDuan"+goodsId+"']");
		    var useBudgeRadios = useBudgeDiv.find(":radio");
		    useBudgeDiv.show();
		    useBudgeRadios.eq(0).removeAttr("checked").attr("disabled","disabled")
		    useBudgeRadios.eq(1).attr("checked","checked").attr("disabled","disabled")

		    //如果是否隐藏
		    showPreControl(useBudgeRadios.eq(1));
		   
		    
		    if($("#radio1").is(":checked")||$("#radio2").is(":checked")){
		    $("#hideShow").hide();
		    $("#hideshow2").hide();
		    }
		    useBudgeDiv.hide();
		 }else
		 {	var useBudgeDiv = $("#price_set_pre").find("div[div='useMaiDuan"+goodsId+"']");
		    var useBudgeRadios = useBudgeDiv.find(":radio");
		    useBudgeDiv.show();	   
		    var nameStr = 'isPreControlPrice'+goodsId;		  
		    var obj = $("input[name="+nameStr+"][type=radio][class*=closeBudgePrice]:checked");
		    preDiv.show();
		    preDiv.find("input[type=radio]").removeAttr("disabled");
		    if(obj.val()=='Y')
		    {		     
		     preDiv.find("input[type=text]").removeAttr("disabled");
		    }
		  auditSettlementPrice_pre.attr("disabled","disabled");	
		  childSettlementPrice_pre.attr("disabled","disabled");
		  auditPrice_pre.attr("disabled","disabled");			
		  childPrice_pre.attr("disabled","disabled");
		  showPreDom1($(":radio[name=isPreControlPrice"+goodsId+"]:checked"));
		 }

	}	
	

</script>

</body>
</html>
