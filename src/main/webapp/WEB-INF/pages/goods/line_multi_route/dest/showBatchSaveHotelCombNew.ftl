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

	 <#assign comboDinnerList = goodsMap['combo_dinner'] />
	 <#if comboDinnerList?? && comboDinnerList?size gt 0>
	
	<div class="row">
		
			<div class="col w80 mr10 text-right text-gray">套餐：</div>
			<div class="col w650">
		 		<#list comboDinnerList as comboDinnerGoods>
		 			<label class="checkbox" <#if comboDinnerGoods.cancelFlag!='Y'>cancelFlag="Y"</#if> > 
		 				<input type="checkbox" class="checkGoods comb_hotel" name="suppGoodsId" value="${comboDinnerGoods.suppGoodsId}"  data_name="${comboDinnerGoods.goodsName}" data_price_type="${comboDinnerGoods.priceType}" supplier_id="${comboDinnerGoods.supplierId}"/>${comboDinnerGoods.goodsName}[${comboDinnerGoods.suppGoodsId}]
		 			</label>
		 			<#assign mainProdBranchId = '${comboDinnerGoods.productBranchId}' />
	 				<#assign mainSuppGoodsId = '${comboDinnerGoods.suppGoodsId}' />
		 		</#list>
		    </div>		 
	</div>
	</#if>
 
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
    <input type="hidden" name="categoryCode" id="categoryCode" value="${categoryCode}" >
	<input type="hidden" name="cancelStrategy" id="cancelStrategy">
	<div style="display:none" id="timePriceFormContent"></div>
</form>

	<form id="timePriceFormInput">
    <div>
        <ul class="nav-tabs JS_tab_main">
            <li class="active">设置库存</li>
            <li>设置价格</li>            
            <li>设置提前预定时间</li>
            <li>设置退改规则</li>
            <li>设置适用行程</li>
            <li>设置买断价格</li>
            <li>设置预售价格</li>
        </ul>
        <div class="tab-content">
            <!--设置库存 开始-->
            <div class="tab-pane active" id="stock_set">
			<!--套餐库存模板-->
			<#assign comboDinnerList = goodsMap['combo_dinner'] />
			<#list comboDinnerList as comboDinnerGoods>
	 	    	<#if comboDinnerGoods??>
				    <div class="row JS_radio_switch_group" goodsId="${comboDinnerGoods.suppGoodsId}" data="stockDiv">
				    </div>
				</#if>
			</#list>
			<!--附加库存模板-->
			<#assign additionList = goodsMap['addition'] />
	 		<#list additionList as additionGoods>
	 			<div class="row JS_radio_switch_group" goodsId="${additionGoods.suppGoodsId}" data="stockDiv">
		    	</div>
	 		</#list>	            	
	 		
            </div>
            <!--设置库存 结束-->

            <!--设置价格 开始-->
            <div class="tab-pane" id="price_set">
            
			<!--套餐价格模板-->
			<table style="margin-left:115px;margin-bottom:20px;" width="80%">
			    <thead>
				    <tr>
				        <th width="16%" align="left">批量操作</th>
				         <th width="16%">
				           <input type="radio" name="branchSale" value='true' id="branchSaleFlag"/>开售
				           <input type="radio" name="branchSale" value='false' id="branchForbidSaleFlag"/>禁售
				        </th>
				        <th width="16%"><label> 结算：</label><input  type="text" id="branchAdultSettlePrice" class="w50 form-control"
                                  max="999999999"/></th>
				        <th width="25%" align="left">
								<select id="branchPriceSelect" class="w85 form-control">
									<option value="custom" selected="selected">自定义</option>
									<option value="fixed">固定加价</option>
									<option value="percent">比例加价</option>
									<option value="equal">结=售</option>
								</select>
				             <input type="text" id="branchAddPrice" readonly="true" class="w50 form-control"  max="999999999"/>
				              <span class="JS_price_percent" style="display:none;">%</span>
				      </th>
				     <th align="left"><label> 销售：</label><input  type="text" id="branchAdultPrice" class="w50 form-control" max="999999999"/></th>
				    </tr>
			    </thead>
			</table>
			<#assign comboDinnerList = goodsMap['combo_dinner'] />
			<#list comboDinnerList as comboDinnerGoods>
		 	   <#if comboDinnerGoods??>
			   <div class="row JS_price_group" goodsId="${comboDinnerGoods.suppGoodsId}" data="priceDiv" divTag="combo_dinner">
			   </div>	
			   </#if>
			</#list>
			
			<!--附加价格模板-->
			<#assign additionList = goodsMap['addition'] />
	 		<#list additionList as additionGoods>
		    	<#if additionGoods??>
		    	<div class="row JS_price_group" goodsId="${additionGoods.suppGoodsId}" data="priceDiv" divTag="addition">
		    	</div>
		    	</#if>	
	 		</#list>	    
            </div>
            <!--设置价格 结束-->

            <!--设置提前预定时间 开始-->
            <div class="tab-pane" id="aheadBookTime_set">
            	<!--套餐提前预定时间模板-->
            	<#assign comboDinnerList = goodsMap['combo_dinner'] />
				<#list comboDinnerList as comboDinnerGoods>
				    <#if comboDinnerGoods??>
				        <div  goodsId="${comboDinnerGoods.suppGoodsId}"  class="row" data="timeDiv_date" ></div>
		                 <div  goodsId="${comboDinnerGoods.suppGoodsId}"  class="row" data="timeDiv_limit"></div>	
						</#if>
				  </#list>



				<!--附加提前预定时间模板-->
				<#assign additionList = goodsMap['addition'] />
		 		<#list additionList as additionGoods>
			    	<#if additionGoods??>
			    	    <div  goodsId="${additionGoods.suppGoodsId}"  class="row" data="timeDiv_date" ></div>
                        <div  goodsId="${additionGoods.suppGoodsId}"  class="row" data="timeDiv_limit"></div>	
			    	</#if>	
		 		</#list>	                
            </div>
            <!--设置提前预定时间 结束-->

            <!--设置退改规则 开始-->
            <div class="tab-pane" id="strategyContainer">
                <div class="tip m10">
                    <span class="text-danger">注：退改规则针对所有商品有效</span>
                </div>
                <div class="row">
                    <div class="col w110 mr10 text-right text-gray">退改规则：</div>
                    <#if productBu=='OUTBOUND_BU'><#--酒店套餐屏蔽人工退改 产品经理：刘政-->
                    <div class="col w100 pl10">
                        <label class="radio">
                            <input type="radio" checked name="retreatRule"  data="selectCancelStrategy" value="MANUALCHANGE" checked/>
                            人工退改
                        </label>
                    </div>
                    </#if>
                    <div class="col w100">
                        <label class="radio">
                            <input type="radio" name="retreatRule" data="selectCancelStrategy" value="UNRETREATANDCHANGE"/>
                            不退不改
                        </label>
                    </div>
                    <div  <#--<#if productBu!="DESTINATION_BU">style="display: none;"</#if>--> class="col w100">
						<label class="radio"> <input type="radio" value="RETREATANDCHANGE" name="retreatRule" data="selectCancelStrategy" /> 可退改</label>
					</div>
					<div class="col w100">
						<input type="button" value="新增退改规则" id="btnAddLadder" disabled style="display:none;"/>
					</div>										
                </div>
                <!-- ooooooooooooooooooooooooooooooooooooooooooooo -->
		
				<!--设置阶梯退改规则开始-->
				<div id="ladderRetreatContainer">
					
					<#-- 阶梯退改规则【ladderRetreatContainer】 模板 -->
					
				</div>
                <div  id="cancelTimeTypeDiv" class=""  style="padding:10px 50px;display: none; " >
                    <input type="checkbox" id="cancelTimeType" checked onclick="return false" name="cancelTimeType" value="OTHER"/>不满足以上条件，用户申请
						<select class="w80 form-control" id="ladderRetreat_type_indexId" name="ladderRetreatType">
							<option value="REFUND">退款</option>
							<option value="CHANGE" disabled="disabled" >改期</option>
						</select>
					扣除套餐费用

                    <select class="w80 form-control" id="ladderRetreat_rule_indexId" name="ladderRetreatRule">
                        <option value="AMOUNT">固定金额(元)</option>
                        <option value="PERCENT">百分比(%)</option>
                    </select>

                    <input class="w40 form-control" id="ladderRetreat_value_indexId" name="ladderRetreatValue"
                           data-validate="{regular:true}" data-validate-regular="^\d{1,8}(\.\d{1,2})?$" max="9999999"
                           type="text" />
                </div>
				<!--设置阶梯退改规则 结束-->
				<!-- ooooooooooooooooooooooooooooooooooooooooooooo -->
                
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
        	<#assign comboDinnerList_pre = goodsMap['combo_dinner'] />
			<#list comboDinnerList_pre as comboDinnerGoods>
		 	    <#if comboDinnerGoods??>
			    <div class="row JS_price_group isPreMod forbidSaleSingle" <#if comboDinnerGoods.cancelFlag!='Y'>cancelFlag="Y"</#if> goodsId="${comboDinnerGoods.suppGoodsId}" data="priceDiv" divTag="combo_dinner" ></div>	
				</#if>
			</#list>	
        </div>
        <!--设置买断价格 结束-->
        <!--设置预售价格 开始-->
       <div  class="tab-pane" id="Set_PreSale">
         <#assign comboDinnerList = goodsMap['combo_dinner'] />
		 <#list comboDinnerList as comboDinnerGoods>
		 	    <#if comboDinnerGoods??>
			         <div  goodsId="${comboDinnerGoods.suppGoodsId}" class="row"  data="preSaleDiv" >
			    	</div>
				</#if>
		  </#list>
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

	<#--阶梯退改模板-->
	<div id="ladder_retreat_template">
		<div class="row">
			<div class="col w10 mr10 text-right text-gray">{{}}、</div>
			<div class="col w40">提前</div>
			<div class="col w100">
				<label> 
				<select class="w80 form-control" id="ladderRetreatTime_day_{indexId}" name="ladderRetreatTime_day">
					<option value="-1" selected="selected">请选择</option>
					<#list 0..999 as i>
	              	<option value="${i}">${i}</option>
	              	</#list>
				</select>
				 天</label>
			</div>
			<div class="col w100">
				<label> 
				<select class="w80 form-control" id="ladderRetreatTime_hour_{indexId}" name="ladderRetreatTime_hour">
				<option value="-1" selected="selected">请选择</option>
				<#list 0..23 as i>
		        	<option value="${i}"  >${i}</option>
		        </#list>
				</select> 点</label>
			</div>
			<div class="col w120">
				<label> 
				<select class="w80 form-control" id="ladderRetreatTime_minute_{indexId}" name="ladderRetreatTime_minute">
					<option value="-1" selected="selected">请选择</option>
					<#list 0..59 as i>
			        	<option value="${i}"  >${i}</option>
			        </#list>
				</select> 分，</label>
			</div>
			
			<div class="col w50">用户申请</div>
			<div class="col w100">
				<label> 
				<select class="w80 form-control" id="ladderRetreat_type_{indexId}" name="ladderRetreatType">
					<option value="REFUND">退款</option>
					<option value="CHANGE" disabled="disabled" >改期</option>
				</select>
				</label>
			</div>
			
			<div class="col w100">扣款套餐费用</div>
			<div class="col w100">
				<label> 
				<select class="w80 form-control JS_ladder_price_rule" id="ladderRetreat_rule_{indexId}" name="ladderRetreatRule" onchange="changeLadderRetreatRule({indexId})">
					<option value="AMOUNT">固定金额</option>
					<option value="PERCENT">百分比</option>				
				</select>
				</label>
			</div>
			
			<div class="col w70">
				<div class="form-group">
				<input class="w40 form-control" id="ladderRetreat_value_{indexId}" name="ladderRetreatValue"
					data-validate="{regular:true}" data-validate-regular="^\d{1,8}(\.\d{1,2})?$" max="9999999"
					type="text" /></div> <span class="JS_ladder_price_percent">元</span>
			</div>
			
			<div class="col w70">
				<a href="javascript:" onclick="deleteLadderRetreatRule({indexId})">删除</a>
			</div>			
						
		</div>
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
                                      max="999999999" name="auditSettlementPrice{index}"  id="adultSettlePrice_{isInput}"
                                      data="auditSettlementPrice"
                                      data_type="is_input" goods="adult{isInput}"/>
                                    </label>
                                </div>
                            </div>
                            <div class="col w90">
                                <select class="w85 form-control JS_price_rule" id="priceSelect_{isInput}">
                                    <option value="custom">自定义</option>
                                    <option value="fixed">固定加价</option>
                                    <option value="percent">比例加价</option>
                                    <option value="equal">结=售</option>
                                </select>
                            </div>
                            <div class="col w80">
                            <div class="form-group">
                                <input class="w50 form-control JS_price_added" data-validate="{regular:true}" id="addPrice_{isInput}"
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
	                        		  data="auditPrice" id="adultPrice_{isInput}"
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
                                      max="999999999" name="childSettlementPrice{index}" id="childSettlePrice_{isInput}"
                                      data="childSettlementPrice"
                                      data_type="is_input" goods="child{isInput}"/>
                                    </label>
                                </div>
                            </div>
                            <div class="col w90">
                                <select class="w85 form-control JS_price_rule" id="childPriceSelect_{isInput}">
                                    <option value="custom">自定义</option>
                                    <option value="fixed">固定加价</option>
                                    <option value="percent">比例加价</option>
                                    <option value="equal">结=售</option>
                                </select>
                            </div>
                            <div class="col w80">
                                <div class="form-group">
                                    <input class="w50 form-control JS_price_added" data-validate="{regular:true}" id="addChildPrice_{isInput}"
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
				                          data="childPrice" id="childPrice_{isInput}"
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
        <div class="col w50" style="width: 110px;">{{}}<div style="line-height:0px;">[{isInput}]</div></div>
         <div class="col">
            <div class="form-group">
                <label class="checkbox">
                 <input type="radio" name="adult_{isInput}" class="onSaleFlagClass" value='Y' goods="adult{isInput}" goodsId="{isInput}" onchange='onAndDownControl($(this),0)' /> 开售
                 <input type="radio" name="adult_{isInput}" class="forbidSaleFlagClass" value='N' goods="adult{isInput}" goodsId="{isInput}" onchange='onAndDownControl($(this),1)'/>
                      禁售
                 <input id="adultSaleFlag_{isInput}" data="saleAble" style="display:none;" goodsId="{isInput}" value="" class="adultSaleFlag" type="checkbox"/>
                 </label>
            </div>
        </div>
        <div class="col w100">
            <div class="form-group">
                <label>
                                  结算：<input class="w50 form-control JS_price_settlement branchModifyClass branchForbidSaleFlag branchValueClass" id="adultSettlePrice_{isInput}" data-validate="{regular:true}"
                              data-validate-regular="{data-validate-regular}" type="text"
                              max="999999999" name="auditSettlementPrice_{index}" data="auditSettlementPrice"  data_type="is_input" goods="adult{isInput}"/>
                </label>
            </div>
        </div>
        <div class="col w90">
            <select class="w85 form-control JS_price_rule branchModifyClass branchForbidSaleFlag branchPriceSelect" id="priceSelect_{isInput}">
                <option value="custom">自定义</option>
                <option value="fixed">固定加价</option>
                <option value="percent">比例加价</option>
                <option value="equal">结=售</option>
            </select>
        </div>
        <div class="col w80">
            <div class="form-group">
                <input class="w50 form-control JS_price_added branchModifyClass branchForbidSaleFlag percentClass" id="addPrice_{isInput}" data-validate="{regular:true}"
                       data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$" type="text"/>
                <span class="JS_price_percent">%</span>
            </div>
        </div>
        <div class="col w110">
            <div class="form-group">
                <label>
                   		 销售：<input class="w50 form-control JS_price_selling branchModifyClass branchForbidSaleFlag" id="adultPrice_{isInput}" data-validate="{regular:true}"
                              data-validate-regular="{data-validate-regular}" type="text"
                              max="999999999" name="auditPrice_{index}" data="auditPrice" data_type="is_input" goods="adult{isInput}"
                              data-validate-readonly="true"/>
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
			    <div class="col w110 mr10"></div>
			              是否启用买断价：<input type='radio' value='Y' class="useBudgePrice" name='useBudgePrice{isInput}' goodsId='{isInput}'  onchange='showPreControl($(this))'   />是&nbsp;
			     <input  type='radio' value='N' class="notUseBudgePrice" name='useBudgePrice{isInput}'goodsId='{isInput}'   onchange='showPreControl($(this))' checked />否&nbsp;
			     <a class="btn" id="syncPrice" style="display:none" goodsId='{isInput}'  onclick='syncBudgePrice($(this))'>价格同步</a>
		    </div>
		    <div style='width:100%' class='bindControlProject{isInput}'>
		    	<div class="col w110 mr10"></div>
	     		<div style="float:left;">绑定预控项目：</div>	
				<input type="hidden" id="resPrecontrolIds{isInput}" name="resPrecontrolIds" />
		       	<a class="btn" id="bindControlProject" style="display: inline-block;" goodsid="{isInput}" suppid="{supplierId}" onclick="bindControlProject($(this))">绑定</a>
		       	<div style="float:left;" id="selectPreControlName"></div>
			</div>  
	</div>   
    <!-- 多价格库存 --> 
       <div id="multiple_stock_template_new">
       		 <div class="col w110 mr10 text-right text-gray">{{}}</div>
                    <div class="JS_radio_switch_box">
                        <div class="col w120">
                            <label class="radio">
                                <input type="radio" class="JS_radio_switch" name="adultStock" value="INQUIRE_NO_STOCK" data="stockType" onchange='deletePreControlByType($(this))' />
                                现询
                            </label>
                        </div>
                    </div>
                    <div class="JS_radio_switch_box" style="display: none">
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
                    <div class="JS_radio_switch_box">
                        <div class="col w90">
                            <label class="radio">
                                <input type="radio" class="JS_radio_switch" name="adultStock" value="CONTROL" data="stockType" onchange='deletePreControlByType($(this))' />
                                切位/库存
                            </label>
                        </div>
                        <div class="col w50">
                        	<div class="form-group">
                        	<input class="w40 form-control JS_radio_disabled" disabled type="text" 
                        	data-validate="{regular:true}" data-validate-regular="^\d*$" max="999999999"/>
                        	</div>
                        </div>
                        <div class="col w140">(总库存，含已售库存)</div>
                    </div>
                    <div class="col w60">可超卖：</div>
                    <div class="col w50">
                        <label class="radio">
                            <input type="radio" checked name="oversellFlag_{index}"  data="oversellFlag" value="N"  />
                            否
                        </label>
                    </div>
                    <div class="col w50">
                        <label class="radio mr10">
                            <input type="radio" name="oversellFlag_{index}" data="oversellFlag" value="Y"/>
                            是
                        </label>
                    </div>
       
       
       
       </div> 
	         
        <!-- 提前预定时间 -->  
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
                        	   <option value="NONE">无限制</option>
	                    	   <option value="PREAUTH">一律预授权</option>
	                    	   <option value="NOT_PREAUTH">不使用预授权</option>
                        	<#elseif defaultBookLimitType=="NOT_PREAUTH">
                        	   <option value="NOT_PREAUTH">不使用预授权</option>
                        	   <option value="NONE">无限制</option>
	                    	   <option value="PREAUTH">一律预授权</option>
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
		<div id="hideshow2"class="col w590 isPreControlDiv{isInput}" div="useBudgePriceDiv{isInput}">
		     <lable>是否启用买断价</lable>
		     <input type='radio' value='Y' class="useBudgePrice" name='useBudgePrice{isInput}' goodsId='{isInput}'  onchange='showPreControl($(this))'  />是&nbsp;
		     <input type='radio' value='N' class="notUseBudgePrice" name='useBudgePrice{isInput}' goodsId='{isInput}' onchange='showPreControl($(this))'  checked />否&nbsp;
		     <a class="btn" id="syncPrice" style="display:none" goodsId='{isInput}'  onclick='syncBudgePrice($(this))'>价格同步</a>
		</div>
        <div class="col w550 isPreControlDiv{isInput}" >
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
                <div class="col w50">结算：</div>
                <div class="col w150">
                    <div class="form-group">
                        <label>
                           <input class="w100 form-control JS_price_settlement"  data-validate="{regular:true}" 
                          type="text"  data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$"
                          max="999999999" name="showPreSale_pre"  data="showPreSale_pre" data_type="is_input" goods="adult{isInput}" />
                        </label>
                    </div>
                </div>
               </div>
             </div>
       </div>
	</div>
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
		     //新增退改规则按钮-事件
			 $("#strategyContainer").delegate("#btnAddLadder","click",ladderEventHandler);	
		     $('input[name=retreatRule]').click(function(){
				if(this.value == "RETREATANDCHANGE"){
					$("#btnAddLadder").removeAttr("disabled");
					$("#btnAddLadder").show();
					$("#ladderRetreatContainer").show();
                    $("#cancelTimeTypeDiv").show();
				}else{
					$("#btnAddLadder").attr("disabled", true);
					$("#btnAddLadder").hide();
					$("#ladderRetreatContainer").hide();
                    $("#cancelTimeTypeDiv").hide();
				}
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
				    $("#Set_PreSale").find("input[name='showPreSale_pre']").removeAttr("disabled");
				}else if(obj.value=="false")
				{
					//如果是批量禁售
					$(".forbidSaleFlagClass").attr("checked","true");
					$(".adultSaleFlag").attr("checked","true");
					$(".adultSaleFlag").val("1");
					$("#Set_PreSale").find("input[name='showPreSale_pre']").attr("disabled","disabled");
					$("#Set_PreSale").find("input[name='showPreSale_pre']").val("");
					
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
				$(".JS_price_settlement").filter("input[name='showPreSale_pre']").val("");
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
					  $("#Set_PreSale").find("div[goodsId="+goodsId+"][data='preSaleDiv']").find("input[name='showPreSale_pre']").removeAttr("disabled");
				}else if(num==1)
				  {
				    //如果是禁售 
					  $("#adultSaleFlag_"+goodsId).attr("checked","true");
					  $("#adultSaleFlag_"+goodsId).val("1");
					 $("#Set_PreSale").find("div[goodsId="+goodsId+"][data='preSaleDiv']").find("input[name='showPreSale_pre']").attr("disabled","disabled");
					$("#Set_PreSale").find("div[goodsId="+goodsId+"][data='preSaleDiv']").find("input[name='showPreSale_pre']").val("");
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
			
			//退改规则索引
			var ladderIndex = 0;
			
			//添加阶梯退改规则
			function ladderEventHandler(){
				var ladderTemplate = "";
				var res = "^\\d{1,8}(\\.\\d{1,2})?$";
				var container = $("#ladderRetreatContainer");
				ladderTemplate = "<div divType='my_ladder_retreat'>"+$("#ladder_retreat_template").html()+"</div>";
				ladderTemplate = ladderTemplate.replace(/{{}}/g,(ladderIndex+1));
				ladderTemplate = ladderTemplate.replace(/{indexId}/g,ladderIndex);
				ladderTemplate = ladderTemplate.replace(/{data-validate-regular}/g,res);
				var ladderRetreats = $("div[divType=my_ladder_retreat]",$(container));
				if(ladderRetreats.length>0){
					$(ladderTemplate).insertAfter(ladderRetreats.last());
				}else{
					$(container).append(ladderTemplate);
				}
				container.show();
				ladderIndex = ladderIndex+1;
				validInitPrice();
			}	
			//删除阶梯退改规则
			function deleteLadderRetreatRule(index){
				var _div = $("#ladderRetreat_value_"+index).parent().parent().parent();;
				_div.remove();
				for(var i = index+1;i<ladderIndex;i++){
					var day = $('#ladderRetreatTime_day_'+i).val();
				    var hour = $('#ladderRetreatTime_hour_'+i).val();
				    var minute = $('#ladderRetreatTime_minute_'+i).val();
				    var type = $('#ladderRetreat_type_'+i).val();
				    var rule = $('#ladderRetreat_rule_'+i).val();
				    var value = $('#ladderRetreat_value_'+i).val();
				    var ladderTemplate = "";
					var res = "^\\d{1,8}(\\.\\d{1,2})?$";
					var container = $("#ladderRetreatContainer");
					ladderTemplate = "<div divType='my_ladder_retreat'>"+$("#ladder_retreat_template").html()+"</div>";
					ladderTemplate = ladderTemplate.replace(/{{}}/g,(i));
					ladderTemplate = ladderTemplate.replace(/{indexId}/g,i-1);
					ladderTemplate = ladderTemplate.replace(/{data-validate-regular}/g,res);
					var ladderRetreats = $("div[divType=my_ladder_retreat]",$(container));
					if(ladderRetreats.length>0){
						$(ladderTemplate).insertAfter(ladderRetreats.last());
					}else{
						$(container).append(ladderTemplate);
					}
					var _div = $("#ladderRetreat_value_"+i).parent().parent().parent();;
					_div.remove();
					var j = i -1;
					$('#ladderRetreatTime_day_'+j).val(day);
				    $('#ladderRetreatTime_hour_'+j).val(hour);
				    $('#ladderRetreatTime_minute_'+j).val(minute);
				    $('#ladderRetreat_type_'+j).val(type);
				    $('#ladderRetreat_rule_'+j).val(rule);
				    $('#ladderRetreat_value_'+j).val(value);
					container.show();
					changeLadderRetreatRule(j);
				}
				ladderIndex = ladderIndex-1;
				validInitPrice();
			}
			
			//改变阶梯退改中用户申请类型
			function changeLadderRetreatRule(index){
				if($("#ladderRetreat_rule_"+index).val() == "PERCENT"){
					$("#ladderRetreat_value_"+index).parent().next("span[class='JS_ladder_price_percent']").html("%");
				}else{
					$("#ladderRetreat_value_"+index).parent().next("span[class='JS_ladder_price_percent']").html("元");
				}
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
//商品点击事件	
	$(".adult_child,.comb_hotel,.addition,.upgrade,.change_hotel").click(function(){
		var that = $(this);
		var name = that.attr("data_name");
		var priceType = that.attr("data_price_type");
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
		var preSaleTemplate=''; 
		if(priceType=="SINGLE_PRICE"){
			
			priceTemplate = $("#single_price_template_new").html();
			priceTemplate_pre=$("#single_price_template_new_pre").html();
			preSaleTemplate=$("#multiple_preSale_template_new_preSale").html();
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
		
		preSaleTemplate = preSaleTemplate.replace(/{{}}/g,name);
		preSaleTemplate=preSaleTemplate.replace(/{isInput}/g,goodsId);
		
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

            var cancelStrategy = $('input[data=selectCancelStrategy]:checked').val();
            if(!cancelStrategy){
                alert('请选择退改规则');
                return;
            }

        }
		
		//非空判断价格库存
	  	var nullMsg = setValidElementForm();
	  	if(nullMsg!=''){
	  		alert(nullMsg);
	  		return ; 
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
        $("#categoryCode").val();



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
		if(cancelStrategy=="RETREATANDCHANGE"){
			//设置阶梯退改规则数据
	    	setCancelStrategyRules();
		}
	}
	
	//设置阶梯退改规则详情
	function setCancelStrategyRules(){
		for (var i=0;i<ladderIndex;i++){
			var day = $('#ladderRetreatTime_day_'+i).val();
		    var hour = $('#ladderRetreatTime_hour_'+i).val();
		    var minute = $('#ladderRetreatTime_minute_'+i).val();
		    var type = $('#ladderRetreat_type_'+i).val();
		    var rule = $('#ladderRetreat_rule_'+i).val();
		    var clonevalue = $('#ladderRetreat_value_'+i).val();
		    var totalMinutes = getTotalMinute(day,hour,minute);
		    $("#timePriceFormContent").append('<input type="hidden" name="prodRefundRules['+i+'].cancelTime" value="'+totalMinutes+'">');
		    $("#timePriceFormContent").append('<input type="hidden" name="prodRefundRules['+i+'].applyType" value="'+type+'">');
		    $("#timePriceFormContent").append('<input type="hidden" name="prodRefundRules['+i+'].deductType" value="'+rule+'">');
		    
		    var start = clonevalue.lastIndexOf(".");
    		var len = clonevalue.length-1;
    		var decimallen = len - start;  
		    //parseInt精度有问题0.1变0.099
    		if(clonevalue.indexOf(".") == -1){    			
    			inputValue = parseInt(clonevalue*100,0);
    		}else if(decimallen == 1){
    			inputValue = clonevalue.replace(".","")+"0";    			
    		}else if(decimallen == 2){
    			inputValue = clonevalue.replace(".","");
    		}
		    inputValue = parseInt(inputValue);
		    
		    $("#timePriceFormContent").append('<input type="hidden" name="prodRefundRules['+i+'].deductValue" value="'+inputValue+'">');
		}
        if($("#cancelTimeType").attr("checked")){
            var type = $('#ladderRetreat_type_indexId').val();
            var rule = $('#ladderRetreat_rule_indexId').val();
            var clonevalue = $('#ladderRetreat_value_indexId').val();
            var start = clonevalue.lastIndexOf(".");
            var len = clonevalue.length-1;
            var decimallen = len - start;
            if(clonevalue.indexOf(".") == -1){
                inputValue = parseInt(clonevalue*100,0);
            }else if(decimallen == 1){
                inputValue = clonevalue.replace(".","")+"0";
            }else if(decimallen == 2){
                inputValue = clonevalue.replace(".","");
            }
            inputValue = parseInt(inputValue);
            $("#timePriceFormContent").append('<input type="hidden" name="prodRefundRules['+ladderIndex+'].applyType" value="'+type+'">');
            $("#timePriceFormContent").append('<input type="hidden" name="prodRefundRules['+ladderIndex+'].deductType" value="'+rule+'">');
            $("#timePriceFormContent").append('<input type="hidden" name="prodRefundRules['+ladderIndex+'].deductValue" value="'+inputValue+'">');
            $("#timePriceFormContent").append('<input type="hidden" name="prodRefundRules['+ladderIndex+'].cancelTimeType" value="OTHER">');
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
	    var preDivClass = 'isPreControlDiv'+goodsId;
	
		var adultSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='auditSettlementPrice_pre']");//结算价
		var adultPrice_pre = $("."+preDivClass).find("input[type=text][name='auditPrice_pre']");//销售价
		var adultReadOnlyNum_pre = $("."+preDivClass).find("input[type=text][name='adultReadOnlyNum_pre']");//自定义数值
		
		if(adultSettlementPrice_pre.attr("disabled") != "disabled"){
			adultSettlementPrice_pre.val($("input[type=text][data='auditSettlementPrice'][id='adultSettlePrice_"+goodsId+"']").val());
			var adultPriceRule = $("select[id='priceSelect_"+goodsId+"']").val();
			
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
				adultReadOnlyNum_pre.val($("input[type='text'][id='addPrice_"+goodsId+"']").val());
			}
			adultPrice_pre.val($("input[type='text'][id='adultPrice_"+goodsId+"']").val());
		}
		/*酒店套餐无儿童价
		if(priceType=="MULTIPLE_PRICE"){//多价格模板才有儿童价格模板
			var childSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='childSettlementPrice_pre']");//儿童结算
		    var childPrice_pre = $("."+preDivClass).find("input[type=text][name='childPrice_pre']");//儿童销售
		    var childReadOnlyNum_pre = $("."+preDivClass).find("input[type=text][name='childReadOnlyNum_pre']");//自定义数值
		    
			if(childSettlementPrice_pre.attr("disabled") != "disabled"){
				childSettlementPrice_pre.val($("input[type=text][data='childSettlementPrice'][id='childSettlePrice_"+goodsId+"']").val());
				var childPriceRule = $("select[id='childPriceSelect_"+goodsId+"']").val();
				
				if(childPriceRule != 'custom'){
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
					childReadOnlyNum_pre.val($("input[type='text'][id='addChildPrice_"+goodsId+"']").val());
				}
				childPrice_pre.val($("input[type='text'][id='childPrice_"+goodsId+"']").val());
			}
		}*/    	
	}
	
	//将时间转化为分钟数
	function getTotalMinute(day,hour,minute){
			if(day == -1){
				day =0;
			}
			if(hour == -1){
				hour =0;
			}
			if(minute == -1){
				minute =0;
			}
			return  (day*24*60-hour*60-minute);	
	}
	//设置预售
	function setPreSaleIdData(){
	     var t = 0 ; 
		$("#Set_PreSale").find("div[data='preSaleDiv']").each(function(i){
		    var that = $(this);
		    if($.trim(that.html())!=''){
			  var bringPreSale = that.find("[type=radio]:checked").val();
		   		 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].bringPreSale" value="'+bringPreSale+'">');
		   		 var hotelShowPreSale_pre = that.find("input[name='showPreSale_pre']").val()*100;
		   		 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].hotelShowPreSale_pre" value="'+hotelShowPreSale_pre+'">');
		   		 if(that.find("input[name='showPreSale_pre']").prop("disabled")){
		   		 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].hotelIsBanSell" value="Y">');
		   		 }else{
		   		  $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].hotelIsBanSell" value="N">');
		   		 }
		   		 t++;
			}    
	    });	
	}
	//设置适用行程
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
						var infoMsg = '';
						if(result.attributes){
							if(result.attributes.infoMsg){
								infoMsg = result.attributes.infoMsg;
							}
						}
						alert("保存成功!"+infoMsg);
						resetInitForm();
						window.location.reload();
						
					} else{
						newAlert('保存失败');
					}
				},
				error : function(){
					newAlert('服务器错误');
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
		$(".JS_select_date td.calSelected[date-map]").removeClass("calSelected");
		$(".JS_select_date_hidden option").remove();
		$("input[type=checkbox][name=weekDayAll]").attr("checked",false);
		$("input[type=checkbox][name=weekDay]").attr("checked",false);
		$("input[type=radio][value=selectDate]").attr("checked",true);
		$("input[type=radio][value=MANUALCHANGE]").attr("checked",true);
		$("#d4321").val("");
		$("#d4322").val("");
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
        var timeStr = "";//时间拼接（用以判断是否有重复）
        var numStr = "";//退改金额拼接（用以判断金额是否重复）
		//阶梯退改校验
	    $("#timePriceFormInput").find("div[divtype='my_ladder_retreat']").each(function(i){
		    var that = $(this);
		    var cancelStrategy = $('input[data=selectCancelStrategy]:checked').val();
			if(cancelStrategy=="RETREATANDCHANGE"){
				if($.trim(that.html())!=''){
				    var day = parseInt(that.find("select[name=ladderRetreatTime_day]").val());
					if(day == -1){
						nullMsg = "阶梯退改第"+(i+1)+"条，提前天数不能为空";
						return false;
					}
					var hour = parseInt(that.find("select[name=ladderRetreatTime_hour]").val());
					if(hour == -1){
						nullMsg = "阶梯退改第"+(i+1)+"条，提前小时不能为空";
						return false;
					}
					var minute = parseInt(that.find("select[name=ladderRetreatTime_minute]").val());
					if(minute == -1){
						nullMsg = "阶梯退改第"+(i+1)+"条，提前时间分钟不能为空";
						return false;
					}
                    var time = day+"_"+hour+"_"+minute;
                    if(timeStr.indexOf(time) > 0){
                        nullMsg = "阶梯退改第"+(i+1)+"条，提前时间重复";
                        return false;
                    }
                    timeStr = timeStr + "%" + time;
					var rule = that.find("select[name=ladderRetreatRule]").val();
					var value = that.find("input[name=ladderRetreatValue]").val();
					if(rule == "PERCENT" && value > 100){
						nullMsg = "阶梯退改第"+(i+1)+"条，扣款类型为百分比时，比例不能超过100";
						return false;
					}
					if(rule == "PERCENT" && (value == ""||value=="undefined")){
						nullMsg = "阶梯退改第"+(i+1)+"条，扣款比例不能为空";
						return false;
					}
					if(rule == "AMOUNT" && (value == ""||value=="undefined")){
						nullMsg = "阶梯退改第"+(i+1)+"条，扣款值不能为空";
						return false;
					}
                    var num = rule+"_"+value;
                    if(numStr.indexOf(num) > 0){
                        nullMsg = "阶梯退改第"+(i+1)+"条，扣款值和扣款类型重复";
                        return false;
                    }
				    numStr = numStr + "%" + num;
				}

			}
		        
	    });


        if($('input[data=selectCancelStrategy]:checked').val()=="RETREATANDCHANGE"&&$("#cancelTimeType").attr("checked")) {
            var type = $('#ladderRetreat_type_indexId').val();
            var rule = $('#ladderRetreat_rule_indexId').val();
            var clonevalue = $('#ladderRetreat_value_indexId').val();
            if(rule == "PERCENT" && clonevalue > 100){
                nullMsg = "阶梯退改最后一条，扣款类型为百分比时，比例不能超过100";
            }
            if(rule == "PERCENT" && (clonevalue == ""||clonevalue=="undefined")){
                nullMsg = "阶梯退改最后一条，扣款比例不能为空";
            }
            if(rule == "AMOUNT" && (clonevalue == ""||clonevalue=="undefined")){
                nullMsg = "阶梯退改最后一条，扣款值不能为空";
            }
            if(nullMsg == ""){
                var num = rule+"_"+clonevalue;
                if(numStr.indexOf(num) > 0){
                    nullMsg = "阶梯退改最后一条，扣款值和扣款类型重复";
                    return false;
                }
            }

        }

        //判断阶梯退改规则是否是至少有一条
        if($('input[data=selectCancelStrategy]:checked').val()=="RETREATANDCHANGE"){
            if(ladderIndex == 0 && !$("#cancelTimeType").attr("checked")){
                nullMsg = "可退改规则至少存在一条";
            }
        }


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
		 var preSaleTemp= $("#Set_PreSale").find("div[goodsId="+goodsId+"]");
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

		if(obj.val()=='Y'){
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
		}else{
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
			//酒店套餐露出价格同步按钮
			$("."+preDivClass+" #syncPrice").css("display","inline-block");
		}else
		{
		  $("."+preDivClass).hide();
		  auditSettlementPrice_pre.attr("disabled","disabled");			
		  childSettlementPrice_pre.attr("disabled","disabled");
		  auditPrice_pre.attr("disabled","disabled");			
		  childPrice_pre.attr("disabled","disabled");
		  $("#price_set_pre").find("div[data='priceDiv'][goodsId="+goodsId+"]").removeClass('isPreMod');

		  $("div[div=useBudgePriceDiv"+goodsId+"]").show();
		  //隐藏价格同步按钮
		  $("."+preDivClass+" #syncPrice").css("display","none");
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
		  if(obj.attr("checked")!='checked')
		  {
		    if(num != 'all'){	      
		      $("#price_set_pre").find("div[class*="+type+"]").eq(num).show();
		      $("#price_set_pre").find("div[class*="+type+"]").eq(num).find("input[type=text]").removeAttr("disabled");		      
		    }else{		      	
		      $("#price_set_pre").find("div[class*="+type+"]").show();
		      $("#price_set_pre").find("div[class*="+type+"]").find("input[type=text]").removeAttr("disabled");
		      $("#price_set_pre").find("div[class*="+type+"]").find("input[type=radio]").removeAttr("disabled");
		      $("#price_set_pre").find("div[class*=isPreMod]").show();
		      $("#price_set_pre").find("div[class*=isPreMod]").find("[type=radio]").removeAttr("disabled");
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
		    }else{
		      //全选禁售	      
		      $("#price_set_pre").find("div[class*="+type+"]").hide();
		      $("#price_set_pre").find("div[class*="+type+"]").find("input[type=text]").attr("disabled","disabled");
		      $("#price_set_pre").find("div[class*="+type+"]").find("input[type=text]").val("")
		      $("#price_set_pre").find("div[class*="+type+"]").find("input[type=radio]").attr("disabled","disabled");
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
</script>
</body>
</html>
