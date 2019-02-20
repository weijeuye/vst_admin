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
    <style type="text/css">
    	.red-border-err{
    		border:1px solid red;
    	}
    	.branchStyle
    	{
	    	box-shadow: 2px 2px 2px rgba(0, 0, 0, 0.075) inset;
		    background: #fff;
		    padding: 4px 4px;
		    line-height: 16px;
		    border: 1px solid #aabbcc;
		    resize: vertical;
    	}
    	#branchAdultPrice{
		width: 40px;margin-right: 20px;
		}
		#branchAddPrice{
		width: 40px;
		}		}
		#branchSaleFlag{
		margin-right:5px;
		}
		#branchModify{
		margin-right:5px;
		}
		#branchAdultSettlePrice{
		width:40px;}
    </style>
    </style>
</head>
<body>

<div class="add-product">
<form id="timePriceForm">
    <div class="row">
    	 <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local'>
        <div class="col w80 mr10 text-right text-gray">成人儿童：</div>
        <div class="col w650">
        	<#assign adultChildGoods = goodsMap['adult_child_diff'] />
	 		<#if adultChildGoods??>
 				<label class="checkbox">
 					<input type="checkbox" class="my_adult_child" name="suppGoodsId" value="${adultChildGoods.suppGoodsId}" data_name="${adultChildGoods.goodsName}" data_price_type="${adultChildGoods.priceType}" />
 					${adultChildGoods.goodsName}[${adultChildGoods.suppGoodsId}]
 				</label>
	 		</#if>
        </div>
        </#if>
    </div>
    
    <#if categoryCode=='category_route_hotelcomb'>
    <input type="hidden" id="category_route_hotelcomb_input" value="category_route_hotelcomb"/>
	<#assign comboDinnerList = goodsMap['combo_dinner'] />
	<#if comboDinnerList?? >			
    <div class="row">
    	 <#if categoryCode=='category_route_hotelcomb'>
        <div class="col w80 mr10 text-right text-gray">套餐： 全选<input type="checkbox"  class="my_comb_hotel1" id="orChecked">
        </div>
        <div class="col w650">
	 		<#list comboDinnerList as comboDinnerGoods>
	 			<label class="checkbox" <#if comboDinnerGoods.cancelFlag!='Y'>cancelFlag="Y"</#if> >
	 				<input type="checkbox" class="my_comb_hotel" name="suppGoodsIdList" value="${comboDinnerGoods.suppGoodsId}"  data_name="${comboDinnerGoods.goodsName}" data_price_type="${comboDinnerGoods.priceType}" />
	 					${comboDinnerGoods.goodsName}[${comboDinnerGoods.suppGoodsId}]
	 				</label>
	 			<#assign mainProdBranchId = '${comboDinnerGoods.productBranchId}' />
 				<#assign mainSuppGoodsId = '${comboDinnerGoods.suppGoodsId}' />
	 		</#list>
        </div>
        </#if>
    </div>
    </#if>
    <#else>
     <input type="hidden" id="category_route_hotelcomb_input" value=""/>
    </#if>
    
    <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_hotelcomb'>
    <#assign additionList = goodsMap['addition'] />
    <#if additionList?? &&  additionList?size gt 0>
    <div class="row">
    	<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_hotelcomb'>
        <div class="col w80 mr10 text-right text-gray">附加：</div>
        <div class="col w650">
			<#list additionList as additionGoods>
				 <label class="checkbox"  <#if additionGoods.cancelFlag!='Y'>cancelFlag="Y"</#if>  >
				 <input type="checkbox" class="my_addition" name="suppGoodsId" value="${additionGoods.suppGoodsId}"  data_name="${additionGoods.goodsName}" data_price_type="${additionGoods.priceType}" />
				 	${additionGoods.goodsName}[${additionGoods.suppGoodsId}]
				 </label>
			</#list>	 		
        </div>
        </#if>
    </div>
    </#if>
    </#if>
    
    <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'>
    <#assign upgradList = goodsMap['upgrad'] />
    <#if upgradList?? && upgradList?size gt 0>
    <div class="row">
    	<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'>
        <div class="col w80 mr10 text-right text-gray">升级：</div>
        <div class="col w650">
			<#list upgradList as upgradGoods>
				 <label class="checkbox">
				 	<input type="checkbox" class="my_upgrade" name="suppGoodsId" value="${upgradGoods.suppGoodsId}"  data_name="${upgradGoods.goodsName}" data_price_type="${upgradGoods.priceType}" />
				 	${upgradGoods.goodsName}[${upgradGoods.suppGoodsId}]
				 </label>
			</#list>	 		
        </div>
        </#if>
    </div>
    </#if>
    </#if>
    
    <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'>
    <#assign changedHotelList = goodsMap['changed_hotel'] />
    <#if changedHotelList?size  gt 0 >
    <div class="row">
    	<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'>
        <div class="col w80 mr10 text-right text-gray">可换酒店：</div>
        <div class="col w650">
			<#list changedHotelList as changedHotelGoods>
				 <label class="checkbox">
					 <input type="checkbox" class="my_change_hotel" name="suppGoodsId" value="${changedHotelGoods.suppGoodsId}"  data_name="${changedHotelGoods.goodsName}" data_price_type="${changedHotelGoods.priceType}" />
					 ${changedHotelGoods.goodsName}[${changedHotelGoods.suppGoodsId}]
				 </label>
			</#list>	 		
        </div>
        </#if>
    </div>
    </#if>
    </#if>
    
    <div class="hr"></div>
    <div class="row mt10">
        <div class="col w460 ml10">
            <div class="row">
                <label class="radio">
                    <input type="radio" checked  value="selectDate" name="nfadd_date"/> 选择日期
                </label>
            </div>
            <div class="JS_select_date"></div>
            <select multiple="" id="selDate" class="JS_select_date_hidden"></select>
        </div>
        <div class="col w290">
            <div class="row">
                <label class="radio"><input type="radio" value="selectTime" name="nfadd_date"/> 选择时间段</label>
                <div style="display:none">
		        	<select multiple="true" id="selDate"></select>
		            <br/>
		            <input type="button" value="删除" id="btnDel"/>
		        </div>
            </div>
            <div class="row">
                <div class="col w70 text-right text-gray pr10" > 起始：</div>
                <div class="col w150">
                    <input type="text" id="d4321" class="datetime form-control w170 J_calendar" name="startDate" />
                </div>
            </div>
            <div class="row">
            	<div class="col w70 text-right text-gray pr10" >结束：</div>
                <div class="col w150">
                    <input type="text" id="d4322" class="datetime form-control w170 J_calendar" name="endDate" />
                </div>
            </div>
            <div class="row JS_checkbox_select_all_box">
                <div class="col w70 text-right text-gray pr10">适应日期：</div>
                <div class="col w100">
                    <label><input type="checkbox" class="JS_checkbox_select_all_switch" name="weekDayAll"/>  全部</label>
                </div>
                <div class="col week-group">
                    <p><label><input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="2"/>  周一</label></p>
                    <p><label><input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="3"/>  周二</label></p>
					<p><label><input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="4"/>  周三</label></p>
					<p><label><input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="5"/>  周四</label> </p>
                    <p><label><input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="6"/>  周五</label></p>
                    <p><label><input type="checkbox" class="JS_checkbox_select_all_item"name="weekDay" value="7"/>   周六 </label></p>
                    <p><label><input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="1"/>  周日</label></p>
                </div>
            </div>
        </div>
    </div>

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
			<div class="tab-pane active" id="stockContainer">
				<#-- 库存  模板-->
			</div>
			<!--设置库存 结束-->
			<!-- ooooooooooooooooooooooooooooooooooooooooooooo -->
			
			
			
			<!--设置价格 开始-->
			<div class="tab-pane" id="priceContainer">
			    <#if categoryCode=='category_route_hotelcomb'>
				<table style="margin-left:80px;margin-bottom:5px;" width="90%">
				    <thead>
					    <tr>
					        <th width="15%">批量操作</th>
					        <th width="14%" align="left">
					        <input type="radio" name="branchSale" value='true' class="cleanSelected" id="branchSaleFlag"/>开售
					        <input type="radio" name="branchSale" value='false' class="cleanSelected" id="branchForbidSaleFlag"/>禁售</th>
					        <th width="10%" align="left"><input type="checkbox" id="branchModify" class="branchStyle"/>修改</th>
					        <th width="14%" align="left"><label> 结算：</label><input type="text" class="branchStyle" id="branchAdultSettlePrice"/></th>
					        <th width="25%" align="left">
									<select id="branchPriceSelect" class="branchStyle">
										<option value="custom" selected="selected">自定义</option>
										<option value="fixed">固定加价</option>
										<option value="percent">比例加价</option>
										<option value="equal">结=售</option>
									</select>
					             <input type="text" id="branchAddPrice" class="branchStyle" readonly="readonly"/>
					              <span class="JS_price_percent" style="display:none;">%</span>
					      </th>
					     <th align="left"><label> 销售：</label><input type="text" id="branchAdultPrice" class="branchStyle"/></th>
					    </tr>
				    </thead>
                 </table>
                </#if>
					<#-- 成人价，儿童价，方差【多价格模板】模板 -->
					
					<#-- 附加 相关，【单价格模板】 模板 -->
	
				
			</div>
			<!--设置价格 结束-->
			<!-- ooooooooooooooooooooooooooooooooooooooooooooo -->
	
			<!--设置提前预定时间 开始-->
			<div class="tab-pane" id="headTimeContainer">
				
				<#-- 提前预定时间【ahead_time_template】 模板 -->
				
			</div>
			<!--设置提前预定时间 结束-->
			<!-- ooooooooooooooooooooooooooooooooooooooooooooo -->
	
			<!--设置退改规则 开始-->
			<div class="tab-pane" id="strategyContainer">
				<div class="tip m10">
					<span class="text-danger">注：退改规则针对所有商品有效</span>
				</div>
				<div class="row">
					<div class="col w110 mr10 text-right text-gray">退改规则：</div>
					<#if productBu=='OUTBOUND_BU'><#-- 酒店套餐屏蔽人工退改 产品经理：刘政-->
					<div class="col w100 pl10">
						<label class="radio"> <input type="radio" value="MANUALCHANGE" checked name="selectCancelStrategy" /> 人工退改</label>
					</div>
					</#if>
					<div class="col w100">
						<label class="radio"> <input type="radio" value="UNRETREATANDCHANGE" name="selectCancelStrategy" /> 不退不改</label>
					</div>
					<div  <#--<#if productBu!="DESTINATION_BU">style="display: none;"</#if>--> class="col w100">
						<label class="radio"> <input type="radio" value="RETREATANDCHANGE" name="selectCancelStrategy" /> 可退改</label>
					</div>
					<div class="col w100">
						<input type="button" value="新增退改规则" id="btnAddLadder" disabled  style="display:none;"/>
					</div>
				</div>
				<!-- ooooooooooooooooooooooooooooooooooooooooooooo -->
		
				<!--设置阶梯退改规则开始-->
				<div id="ladderRetreatContainer" style="display:none;">
					
					<#-- 阶梯退改规则【ladderRetreatContainer】 模板 -->
					
				</div>
				<div  id="cancelTimeTypeDiv" class=""  style="padding:10px 50px;display: none; " >
					<input type="checkbox" id="cancelTimeType" checked onclick="return false" name="cancelTimeType" value="OTHER"/>不满足以上条件，用户申请
					<select class="w80 form-control" id="ladderRetreat_type_indexId" name="ladderRetreatType">
						<option value="REFUND">退款</option>
						<option value="CHANGE" disabled="disabled">改期</option>
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
			<!-- ooooooooooooooooooooooooooooooooooooooooooooo -->
	
			<!--设置适用行程 开始-->
			<div class="tab-pane" id="lineRouteContainer">
				<div class="tip m10">
					<span class="text-danger">注：适用行程针对所有商品有效</span>
				</div>
				<div class="row">
					<div class="col w110 mr10 text-right text-gray">适用行程：</div>
					<div class="col w100 pl10">
						<select class="w80 form-control" name="lineRouteId">
							<option value='-1'>请选择</option>
							<#if prodLineRouteList?? && prodLineRouteList?size &gt; 0>
								<#list prodLineRouteList as prodLineRoute>
									<option value='${prodLineRoute.lineRouteId}'>${prodLineRoute.routeName}</option>
								</#list>
							</#if>
						</select>
					</div>
				</div>
			</div>
			<!--设置适用行程 结束-->
			
			<!--设置买断价格开始-->
			<div style="" class="tab-pane" id="priceContainer_pre">
				
	
				
			</div>
			<!--设置买断价格结束-->
			
		     <!--设置预售价格 开始-->
             <div  class="tab-pane" id="Set_PreSale">
            </div>
            <!--设置预售价格 结束-->
		</div>
	</div>

	<div class="row">
		<div class="btn-group text-center">
			<a class="btn btn-primary btn-lg JS_btn_save" id="updateSaleInfoBtn">保存</a> <a
				class="btn btn-lg JS_btn_cancel" id="cancelSaleInfoBtn">取消</a>
		</div>
	</div>
	
	
	<#--放置要提交的数据 -->
	<input type="hidden" name="productId" id="thisProductId" value="${productId}">
	<input type="hidden" name="cancelStrategy" id="cancelStrategy">
	<input type="hidden" name="categoryCode" id="categoryCode"  value="${categoryCode}">
	<div style="display:none" id="timePriceFormContent"></div>
</form>

<#--模板存放地  -->
<div id="templateDiv" style="display:none">
	<!--预售价格设置-->
      <div id="multiple_preSale_template_new_preSale">
        <div class="col w110 mr10 text-right text-gray">{{}}</div>
	     <div style='' div='isPreSale{isInput}' >是否可预售：
		       <input type='radio'  name='bringPreSale{isInput}' value='Y' goodsId='{isInput}' onchange='toIsPreSale($(this),{isInput})' />是&nbsp;
		       <input type='radio'  name='bringPreSale{isInput}' value='N' goodsId='{isInput}' onchange='toIsPreSale($(this),{isInput})'  checked />否
		  </div>
		  <div class="row w550 isPreSaleDiv{isInput}" style="display:none;">
            <div class="row JS_price_group forbidSale">
            <div class="col w110 mr10 text-right text-gray"></div>
                <div class="col w50">结算：</div>
                <div class="col w150">
                    <div class="form-group">
                        <label>
                           <input class="w100 form-control JS_price_settlement"  data-validate="{regular:true}" 
                          type="text"  data-validate-regular="^([1-9]\d{0,8}|[1-9]\d{0,8}\.\d{1,2}|0\.\d{1,2}|0?\.0{1,2}|0)$"
                          max="999999999" name="showPreSale_pre"  data="showPreSale_pre" data_type="is_input" goods="hotel{isInput}" />
                        </label>
                    </div>
                </div>
               </div>
             </div>
       </div>
	<#--库存模板-->
	<div id="setter_stock_template">
		<div class="row JS_radio_switch_group">
			<div class="col w110 mr10 text-right text-gray">{{}}：</div>
			<div class="JS_radio_switch_box">
				<div class="col w120">
					<label class="radio"> <input type="radio"
						class="JS_radio_switch" id="INQUIRE_NO_STOCK_{thisGoodsId}" name="adultStock{index}" value="INQUIRE_NO_STOCK" /> 现询
					</label>
				</div>
			</div>
			<div class="JS_radio_switch_box" style="display: none">
				<div class="col w120">
					<label class="radio"> <input type="radio"
						class="JS_radio_switch" id="INQUIRE_WITH_STOCK_{thisGoodsId}" name="adultStock{index}" value="INQUIRE_WITH_STOCK" /> 现询-已知库存
					</label>
				</div>
				<div class="col w80">
					<div class="form-group">
					<input class="w40 form-control JS_radio_disabled" disabled	type="text" data-validate="{regular:true}" max="9999999" data-validate-regular="^\d{1,8}$" />
					</div>
				</div>
			</div>
			<div class="JS_radio_switch_box">
				<div class="col w90">
					<label class="radio"> <input type="radio"
						class="JS_radio_switch" id="CONTROL_{thisGoodsId}" name="adultStock{index}"  value="CONTROL" /> 切位/库存
					</label>
				</div>
				<div class="col w50">
					<div class="form-group">
					<input class="w40 form-control JS_radio_disabled" disabled	type="text" data-validate="{regular:true}" max="9999999" data-validate-regular="^\d{1,8}$" />
					</div>
				</div>
				<div class="col w140">(总库存，含已售库存)</div>
			</div>
			<div class="col w60">可超卖：</div>
			<div class="col w50">
				<label class="radio"> <input type="radio" checked name="adultOversold{index}" value="N"/> 否	</label>
			</div>
			<div class="col w50">
				<label class="radio mr10"> <input type="radio"	name="adultOversold{index}"  value="Y"/> 是 </label>
			</div>
		</div>
	</div>
	
	
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
					data-validate="regular:true" data-validate-regular="^\d{1,8}(\.\d{1,2})?$" max="9999999"
					type="text" /></div> <span class="JS_ladder_price_percent">元</span>
			</div>
			
			<div class="col w70">
				<a href="javascript:" onclick="deleteLadderRetreatRule({indexId})">删除</a>
			</div>			
						
		</div>
	</div>
	
	<#--提前预定时间模板 -->
	<div id="setter_ahead_time_template">
		<div class="row">
			<div class="col w110 mr10 text-right text-gray">{{}}：</div>
			<div class="col w110">提前预定时间：</div>
			<div class="col w120">
				<label> 
				<select class="w80 form-control" id="aheadBookTime_day_{thisGoodsId}" name="aheadBookTime_day">
					<option value="-1" selected="selected">请选择</option>
					<#list 0..180 as i>
	              	<option value="${i}">${i}</option>
	              	</#list>
				</select>
				 天</label>
			</div>
			<div class="col w120">
				<label> 
				<select class="w80 form-control" id="aheadBookTime_hour_{thisGoodsId}" name="aheadBookTime_hour">
				<!--<option value="-1" selected="selected">请选择</option>-->
				<#list 0..23 as i>
		        	<option value="${i}"  >${i}</option>
		        </#list>
				</select> 点</label>
			</div>
			<div class="col w120">
				<label> 
				<select class="w80 form-control" id="aheadBookTime_minute_{thisGoodsId}" name="aheadBookTime_minute">
					<!--<option value="-1" selected="selected">请选择</option>-->
					<#list 0..59 as i>
			        	<option value="${i}"  >${i}</option>
			        </#list>
				</select> 分</label>
			</div>
		</div>
		<div class="row">
			<div class="col w110 mr10"></div>
			<div class="col w110">预付预授权限制：</div>
			<div class="col w120">
				<select class="w80 form-control" id="bookLimitType_{thisGoodsId}" name="bookLimitType">
					<!--<option value="-1">请选择</option>-->
					<option value="NONE">无限制</option>
	                <option value="PREAUTH">一律预授权</option>
	                <option value="NOT_PREAUTH">不使用预授权</option>
				</select>
			</div>
		</div>
	</div>

	<#-- 多价格模板 --> 
	<div id="setter_multiple_price_template">
		<div class="row">
			<div class="col w590">
				<div class="row JS_price_group">
					<div class="col w110 mr10 text-right text-gray">{{}}：</div>
					<div class="col w60 JS_edit_item">
                    	<label class="checkbox">
                        	<input type="checkbox" class="JS_edit_switch modifybox isPreMod"/>
                            	修改
                        </label>
                    </div>
					<div class="col w50 JS_edit_item">成人价</div>
					<div class="col w100">
						<div class="form-group JS_edit_item">
							<label>结算：<input
								class="w40 form-control JS_price_settlement"
								data-validate="{regular:true}" data-validate-regular="{data-validate-regular}" max="9999999"
								type="text" id="adultSettlePrice_{thisGoodsId}"/>
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
					<div class="col w70">
						<input class="w40 form-control JS_price_added"
							data-validate="{regular:true}" data-validate-regular="{data-validate-regular}"
							type="text" /> <span class="JS_price_percent">%</span>
					</div>
					<div class="col w90">
						<div class="form-group JS_edit_item">
							<label>销售：<input
								class="w40 form-control JS_price_selling"
								data-validate="{regular:true}" data-validate-regular="{data-validate-regular}" max="9999999"
								type="text" id="adultPrice_{thisGoodsId}"/>
							</label>
						</div>
					</div>
					<input class="w50 form-control" type="hidden" value="audit" />
				</div>
				<div class="row JS_price_group">
					<div class="col w110 mr10"></div>
					<div class="col w60 JS_edit_item">
                    	<label class="checkbox">
                        	<input type="checkbox" class="JS_edit_switch modifybox isPreMod"/>
                            	修改
                        </label>
                    </div>
					<div class="col w50 JS_edit_item">儿童价</div>
					<div class="col w100">
						<div class="form-group JS_edit_item">
							<label>结算：<input
								class="w40 form-control JS_price_settlement"
								data-validate="{regular:true}" data-validate-regular="{data-validate-regular}" max="9999999"
								type="text" id="childSettlePrice_{thisGoodsId}"/>
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
					<div class="col w70">
						<div class="form-group">
							<input class="w40 form-control JS_price_added"
								data-validate="{regular:true}" data-validate-regular="{data-validate-regular}"
								type="text" /> <span class="JS_price_percent">%</span>
						</div>
					</div>
					<div class="col w90">
						<div class="form-group JS_edit_item">
							<label> 销售：<input
								class="w40 form-control JS_price_selling"
								data-validate="{regular:true}" data-validate-regular="{data-validate-regular}" max="9999999"
								type="text" id="childPrice_{thisGoodsId}"/>
							</label>
						</div>
					</div>
					<input class="w50 form-control"  type="hidden" value="child" />
				</div>
				<div class="row JS_price_group">
					<div class="col w110 mr10"></div>
					<div class="col w60 JS_edit_item">
                    	<label class="checkbox">
                        	<input type="checkbox" class="JS_edit_switch modifybox isPreMod"/>
                            	修改
                        </label>
                    </div>
					<div class="col w50 JS_edit_item">房差</div>
					<div class="col w100">
						<div class="form-group JS_edit_item">
							<label> 结算：<input
								class="w40 form-control JS_price_settlement" max="9999999"
								data-validate="{regular:true}" data-validate-regular="{data-validate-regular}" max="9999999"
								type="text" id="gapSettlePrice_{thisGoodsId}"/>
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
					<div class="col w70">
						<div class="form-group">
							<input class="w40 form-control JS_price_added" max="9999999"
								data-validate="{regular:true}" data-validate-regular="{data-validate-regular}" 
								type="text" /> <span class="JS_price_percent">%</span>
						</div>
					</div>
					<div class="col w90">
						<div class="form-group JS_edit_item">
							<label> 销售：<input
								class="w40 form-control JS_price_selling"
								data-validate="{regular:true}" data-validate-regular="{data-validate-regular}" max="9999999"
								type="text" id="gapPrice_{thisGoodsId}"/>
							</label>
						</div>
					</div>
					<input class="w50 form-control" type="hidden" value="gap" />
				</div>
			</div>
			<div class="col w160 clearfix">
				<div class="clearfix product-lock-up">
		
					<div class="col w60">
						<div class="mb10">
							<div class="form-group">
								<label class="checkbox"> <input type="checkbox"	class="JS_checkbox_lock_item" onchange='forbidPreContorl($(this),0,"forbidSale")' /> 禁售	</label>
							</div>
						</div>
						<div class="mb10">
							<div class="form-group">
								<label class="checkbox"> <input type="checkbox"	class="JS_checkbox_lock_item" onchange='forbidPreContorl($(this),1,"forbidSale")' /> 禁售	</label>
							</div>
						</div>
						<div>
							<div class="form-group">
								<label class="checkbox"> <input type="checkbox"	class="JS_checkbox_lock_item" /> 禁售	</label>
							</div>
						</div>
					</div>
					<div class="col w80">
						<div class="product-lock-up-all form-group">
							<label> <input type="checkbox"	class="JS_checkbox_lock_all" onchange='forbidPreContorl($(this),"all","forbidSale")' /> 全部禁售</label>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<#---买断价格设置--->
	<div id="setter_multiple_price_template_pre">
		<div class="row">
		    <div class="col w590" div='goodControl{thisGoodsId}'>
		     <lable>是否可预控</lable>
		     <input type='radio' value='Y' class="closeBudgePrice" name='isPreControlPrice{thisGoodsId}' goodsId={thisGoodsId}  onclick='showPreDom($(this))'   />是&nbsp;
		     <input type='radio' value='N' class="closeBudgePrice" name='isPreControlPrice{thisGoodsId}' goodsId={thisGoodsId}  onclick='showPreDom($(this))'  checked/>否
		    </div>
		    <div class="col w590 useResPrecontrolPrice{thisGoodsId}">
		     <lable>是否启用买断价</lable>
		     <input type='radio' value='Y' class="useBudgePrice" name='useBudgePrice{thisGoodsId}'    />是&nbsp;
		     <input type='radio' value='N' class="notUseBudgePrice" name='useBudgePrice{thisGoodsId}' checked   />否
		    </div>
			<div class="col w590 isPreControlDiv{thisGoodsId}">
				<div class="row JS_price_group">
					<div class="col w110 mr10 text-right text-gray">{{}}：</div>
					<div class="col w60 JS_edit_item">
                    	<label class="checkbox">
                        	<input type="checkbox" goodsId={thisGoodsId} class="JS_edit_switch modifybox isPreMod" data-type='adult_pre' name="checkPreBox" />
                            	修改
                        </label>
                    </div>
					<div class="col w50 JS_edit_item">成人价</div>
					<div class="col w100">
						<div class="form-group JS_edit_item">
							<label>结算：<input
								class="w40 form-control JS_price_settlement"
								data-validate="{regular:true}" data-validate-regular="{data-validate-regular}" max="9999999"
								type="text" id="adultSettlePrice_pre_{thisGoodsId}"/>
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
					<div class="col w70">
						<input class="w40 form-control JS_price_added"
							data-validate="{regular:true}" data-validate-regular="{data-validate-regular}"
							type="text" /> <span class="JS_price_percent">%</span>
					</div>
					<div class="col w90">
						<div class="form-group JS_edit_item">
							<label>销售：<input
								class="w40 form-control JS_price_selling"
								data-validate="{regular:true}" data-validate-regular="{data-validate-regular}" max="9999999"
								type="text" id="adultPrice_pre_{thisGoodsId}"/>
							</label>
						</div>
					</div>
					<input class="w50 form-control" type="hidden" value="audit" />
				</div>
				<div class="row JS_price_group">
					<div class="col w110 mr10"></div>
					<div class="col w60 JS_edit_item">
                    	<label class="checkbox">
                        	<input type="checkbox" goodsId={thisGoodsId} class="JS_edit_switch modifybox isPreMod" data-type='child_pre' name="checkPreBox" />
                            	修改
                        </label>
                    </div>
					<div class="col w50 JS_edit_item">儿童价</div>
					<div class="col w100">
						<div class="form-group JS_edit_item">
							<label>结算：<input
								class="w40 form-control JS_price_settlement"
								data-validate="{regular:true}" data-validate-regular="{data-validate-regular}" max="9999999"
								type="text" id="childSettlePrice_pre_{thisGoodsId}"/>
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
					<div class="col w70">
						<div class="form-group">
							<input class="w40 form-control JS_price_added"
								data-validate="{regular:true}" data-validate-regular="{data-validate-regular}"
								type="text" /> <span class="JS_price_percent">%</span>
						</div>
					</div>
					<div class="col w90">
						<div class="form-group JS_edit_item">
							<label> 销售：<input
								class="w40 form-control JS_price_selling"
								data-validate="{regular:true}" data-validate-regular="{data-validate-regular}" max="9999999"
								type="text" id="childPrice_pre_{thisGoodsId}"/>
							</label>
						</div>
					</div>
					<input class="w50 form-control"  type="hidden" value="child" />
				</div>
			</div>
		</div>
	</div>
	<#-- 买断结束 -->
	<#if categoryCode=='category_route_hotelcomb'>
	  <div id="setter_single_price_template">
		<div class="row JS_price_group">
			<div class="col w110 mr10 text-right text-gray"><div class="fujia">附加：</div></div>
			<div class="col w50 JS_edit_item" style="margin-right:20px;">{{}}<p style="line-height: 0px;">[{thisGoodsId}]</p></div>
			<div class="col">
				<div class="form-group">
					<label class="checkbox" id="singleChecked"> 
					 <input type="radio" id="onSaleFlag_{thisGoodsId}" name="forbidSaleSingle_{thisGoodsId}" class="onSaleFlagClass cleanSelected" value='Y' goodsId="{thisGoodsId}" onchange='onAndDownControl($(this),0)' /> 开售
					 <input type="radio" id="forbidSaleFlag_{thisGoodsId}" name="forbidSaleSingle_{thisGoodsId}" class="forbidSaleFlagClass cleanSelected" value='N' goodsId="{thisGoodsId}" onchange='onAndDownControl($(this),1)' /> 禁售	
					 <input type="checkbox" goodsId="{thisGoodsId}" data="saleAble" value="" id="onSaleFlagHidden_{thisGoodsId}" style="display:none" class="JS_checkbox_lock_item branchSaleFlagClass cleanSelected adultSaleFlag"/>
					</label>
				</div>
			</div>
			<div class="col w60 JS_edit_item" style="margin-left:20px;">
            	<label class="checkbox">
                  	<input type="checkbox" goodsId="{thisGoodsId}" class="modifybox branchModify branchModifyPrice branchForbidSaleFlag" id="modifyPrice_{thisGoodsId}" onclick='updatePrice($(this),{thisGoodsId})'/>
                            	修改
                </label>
            </div>
			<div class="col w100">
				<div class="form-group JS_edit_item">
					<label> 结算：<input
						class="w40 form-control JS_price_settlement branchModifyClass branchForbidSaleFlag branchValueClass"
						data-validate="{regular:true}" data-validate-regular="{data-validate-regular}"
						type="text" id="adultSettlePrice_{thisGoodsId}" readonly="readonly"/>
					</label>
				</div>
			</div>
			<div class="col w90">
				<select class="w85 form-control JS_price_rule branchModifyClass branchForbidSaleFlag branchPriceSelect" id="priceSelect_{thisGoodsId}">
					<option value="custom">自定义</option>
					<option value="fixed">固定加价</option>
					<option value="percent">比例加价</option>
					<option value="equal">结=售</option>
				</select>
			</div>
			<div class="col w70">
				<div class="form-group">
					<input class="w40 form-control JS_price_added branchModifyClass branchForbidSaleFlag percentClass" id="addPrice_{thisGoodsId}"
						data-validate="{regular:true}" data-validate-regular="{data-validate-regular}"
						type="text"  readonly="readonly"/> <span class="JS_price_percent">%</span>
				</div>
			</div>
			<div class="col w100" style="margin-left: 31px;">
				<div class="form-group JS_edit_item">
					<label> 销售：<input
						class="w40 form-control JS_price_selling branchModifyClass branchForbidSaleFlag"
						data-validate="{regular:true}" data-validate-regular="{data-validate-regular}"
						type="text" id="adultPrice_{thisGoodsId}"  readonly="readonly"/>
					</label>
				</div>
			</div>
			<input class="w50 form-control " id="peopleType_{thisGoodsId}" type="hidden" value="singleprice" />
		</div>
	</div>
	  <#else>
	<#-- 单价格模板 -->
	<div id="setter_single_price_template">
		<div class="row JS_price_group">
			<div class="col w110 mr10 text-right text-gray"><div class="fujia">附加：</div></div>
			<div class="col w60 JS_edit_item">
            	<label class="checkbox">
                  	<input type="checkbox" class="JS_edit_switch modifybox isPreMod"/>
                            	修改
                </label>
            </div>
			<div class="col w50 JS_edit_item">{{}}</div>
			<div class="col w100">
				<div class="form-group JS_edit_item">
					<label> 结算：<input
						class="w40 form-control JS_price_settlement"
						data-validate="{regular:true}" data-validate-regular="{data-validate-regular}"
						type="text" id="adultSettlePrice_{thisGoodsId}"/>
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
			<div class="col w70">
				<div class="form-group">
					<input class="w40 form-control JS_price_added"
						data-validate="{regular:true}" data-validate-regular="{data-validate-regular}"
						type="text" /> <span class="JS_price_percent">%</span>
				</div>
			</div>
			<div class="col w100">
				<div class="form-group JS_edit_item">
					<label> 销售：<input
						class="w40 form-control JS_price_selling"
						data-validate="{regular:true}" data-validate-regular="{data-validate-regular}"
						type="text" id="adultPrice_{thisGoodsId}"/>
					</label>
				</div>
			</div>
			<div class="col">
				<div class="form-group">
					<label class="checkbox"> <input type="checkbox" goodsId="{thisGoodsId}"  class="JS_checkbox_lock_item" onchange='forbidPreContorl($(this),0,"forbidSaleSingle")' /> 禁售	</label>
				</div>
			</div>
			<input class="w50 form-control " type="hidden" value="singleprice" />
		</div>
	</div>
	 </#if>
	<#-- 买断单价格模板 -->
	<div id="setter_single_price_template_pre">
		<div class="row JS_price_group">
			<div class="col w110 mr10 text-right text-gray showprediv"><div class="fujia">附加：</div></div>
			<div style="float:left" class="showprediv" div='goodControl{thisGoodsId}'>
		     <lable>是否可预控</lable>
		     <input type='radio' class="closeBudgePrice" value='Y' name='isPreControlPrice{thisGoodsId}' goodsId={thisGoodsId}  onclick='showSingleDom($(this))'   />是&nbsp;
		     <input type='radio' class="closeBudgePrice" value='N' name='isPreControlPrice{thisGoodsId}' goodsId={thisGoodsId}  onclick='showSingleDom($(this))' checked/>否&nbsp;&nbsp;&nbsp;
		    </div>
		    <div class="col w590 useResPrecontrolPrice{thisGoodsId}">
		     <lable>是否启用买断价</lable>
		     <input type='radio' value='Y' class="useBudgePrice" name='useBudgePrice{thisGoodsId}'     />是&nbsp;
		     <input type='radio' value='N' class="notUseBudgePrice" name='useBudgePrice{thisGoodsId}'  checked  />否
		    </div>
		    <div class="col w590 isPreControlDiv{thisGoodsId}">
				<div class="col w60 JS_edit_item">
	            	<label class="checkbox">
	                  	<input type="checkbox" goodsId={thisGoodsId} class="JS_edit_switch modifybox isPreMod" />
	                            	修改
	                </label>
	            </div>
				<div class="col w50 JS_edit_item">{{}}</div>
				<div class="col w100">
					<div class="form-group JS_edit_item">
						<label> 结算：<input
							class="w40 form-control JS_price_settlement"
							data-validate="{regular:true}" data-validate-regular="{data-validate-regular}"
							type="text" id="adultSettlePrice_pre_{thisGoodsId}"/>
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
				<div class="col w70">
					<div class="form-group">
						<input class="w40 form-control JS_price_added"
							data-validate="{regular:true}" data-validate-regular="{data-validate-regular}"
							type="text" /> <span class="JS_price_percent">%</span>
					</div>
				</div>
				<div class="col w100">
					<div class="form-group JS_edit_item">
						<label> 销售：<input
							class="w40 form-control JS_price_selling"
							data-validate="{regular:true}" data-validate-regular="{data-validate-regular}"
							type="text" id="adultPrice_pre_{thisGoodsId}"/>
						</label>
					</div>
				</div>
			</div>
			<input class="w50 form-control " type="hidden" value="singleprice" />
		</div>
	</div>
</div>
</div>
<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script type="text/javascript">

	//一键控制全选
	$('#orChecked').change(function(){
		 if($(this).is(':checked')){
		 	$("input[name='suppGoodsIdList']").attr('checked',true);
	 		$("input[name='suppGoodsIdList']:checked").each(function(){
	 			goodsEventHandler1($(this));
	 		});
		 }else{
		 	$("input[name='suppGoodsIdList']").attr('checked',false);
		 	$("input[name='suppGoodsIdList']").not("input:checked").each(function(){
		 		goodsEventHandler1($(this));
		 	});
		 } 
	});

	var hideLabel = false;
	var categoryCode="";
	<#if categoryCode=='category_route_hotelcomb'>
		hideLabel = true;
		$(function(){
		//批量开售或禁售事件
		$(document).delegate("input[name='branchSale']","click",function(e) {
		     var obj = e.currentTarget;
			 branchSaleFlag(obj);
	    });
		//批量修改选中事件
		$(document).delegate("#branchModify","click",function(e) {
		     var obj = e.currentTarget;
		     branchModify(obj);
	    });
		//批量设置结算价
	     $(document).delegate("#branchAdultSettlePrice","change",function(e) {
	        var obj = e.currentTarget;
	        branchAdultSettlePrice(obj);
	     });
	     //批量加价
	     $(document).delegate("#branchPriceSelect","change",function(e) {
		     var obj = e.currentTarget;
		     branchPriceSelect(obj);
	     });
	     $(document).delegate("#branchAddPrice","change",function(e) {
		     var obj = e.currentTarget;
		     branchAddPrice(obj);
	  });
	   //批量销售价赋值
	     $(document).delegate("#branchAdultPrice","change",function(e) {
		      var obj = e.currentTarget;
		      branchAdultPrice(obj);
	     });   
	});
	 	function updatePrice(obj,goodsId)
		{
			var checkValue = obj.attr("checked");
			if(checkValue == 'checked')
			{
				$("#adultSettlePrice_"+goodsId).removeAttr("disabled").removeAttr("readonly");
				$("#priceSelect_"+goodsId).removeAttr("disabled").removeAttr("readonly");
				$("#addPrice_"+goodsId).removeAttr("disabled").removeAttr("readonly");
				$("#adultPrice_"+goodsId).removeAttr("disabled").removeAttr("readonly");
			}else{
				$("#adultSettlePrice_"+goodsId).val("");
				$("#addPrice_"+goodsId).val("");
				$("#adultPrice_"+goodsId).val("");
				$("#adultSettlePrice_"+goodsId).attr("readonly","readonly");
				$("#priceSelect_"+goodsId).attr("readonly","readonly");
				$("#priceSelect_"+goodsId).attr("disabled","disabled");
				$("#addPrice_"+goodsId).attr("readonly","readonly");
				$("#adultPrice_"+goodsId).attr("readonly","readonly");
			}
		}
		
		function branchSaleFlag(obj)
		{
			//如果是批量开售
			var goodsId=$(obj).parents("#priceContainer").find("div.priceDiv").attr("goodsId");
			if(obj.value=="true")
			{
				$(".onSaleFlagClass").attr("checked","true");
				$(".adultSaleFlag").val("1");
				$(".branchSaleFlagClass").removeAttr("checked");
				$("#Set_PreSale").find("input[name='showPreSale_pre']").removeAttr("disabled");
			}else if(obj.value=="false")
			{
				//如果是批量禁售
				$(".branchSaleFlagClass").attr("checked",true);
				$(".forbidSaleFlagClass").attr("checked","true");
				$(".adultSaleFlag").val("1");
				 $("#Set_PreSale").find("input[name='showPreSale_pre']").attr("disabled","disabled");
				 $("#Set_PreSale").find("input[name='showPreSale_pre']").val("");
			} 
		}
		//批量修改
		function branchModify(obj)
		{
			var checkedValue = obj.checked;
			if(checkedValue == true)
			{
				$("#branchAdultSettlePrice").removeAttr("readonly");
				$("#branchPriceSelect").removeAttr("readonly");
				$("#branchAddPrice").attr("readonly","readonly");
				$("#branchAdultPrice").removeAttr("readonly");
				$(".branchModifyClass").removeAttr("readonly");
				$(".JS_price_rule").removeAttr("readonly").removeAttr("disabled");
				$(".branchModify").attr("checked","true");
			}else if(checkedValue == false)
			{
				$("#branchAdultSettlePrice").val("");
				$("#branchAddPrice").val("");
				$("#branchAdultPrice").val("");
				$(".JS_price_settlement").val("");
				$(".JS_price_added").val("");
				$(".JS_price_selling").val("");
				$("#branchAdultSettlePrice").attr("readonly","readonly");
				$("#branchPriceSelect").attr("readonly","readonly");
				$("#branchAddPrice").attr("readonly","readonly");
				$("#branchAdultPrice").attr("readonly","readonly");
				$(".branchModifyClass").attr("readonly","readonly");
				$(".branchModify").removeAttr("checked");
				
			}
		}
		//批量设置结算价
		function branchAdultSettlePrice(obj)
		{
			//结算价
			branchAdultSettlePriceValue	 = obj.value;
			//加价类型
			var branchPriceType = $("#branchPriceSelect").val();
			//加价值
			var branchAddPriceValue = $("#branchAddPrice").val();
			var flag = validataData(obj, branchAdultSettlePriceValue);
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
			if(branchAdultSettlePriceValue=="")
				{
				 $("#branchAdultPrice").val("");
				 $(".JS_price_selling").val("");
				}
		$(".JS_price_settlement").filter("input[name='showPreSale_pre']").val("");
		};
		//批量加价
		function branchPriceSelect(obj)
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
			    $("#branchAddPrice").attr("readonly","readonly");
			    $("#branchAdultPrice").removeAttr("readonly");
			    $(".JS_price_percent").css("display","none");
			    $(".JS_price_added").attr("readonly","readonly");
			    $(".JS_price_selling").removeAttr("readonly");
			    $("#branchAddPrice").val("");
			    $(".JS_price_added").val("");
			    $(".JS_price_selling").val("");
			    $("#branchAdultPrice").val("");
			}else if($objValue=="fixed")
			{
				branchAdultSettlePriceValue = $("#branchAdultSettlePrice").val();
				$("#branchAddPrice").removeAttr("readonly");
				$("#branchAdultPrice").attr("readonly","readonly");
				$(".JS_price_percent").css("display","none");
				$(".JS_price_added").removeAttr("disabled").removeAttr("readonly");
				$(".JS_price_selling").attr("readonly","readonly");
				$("#branchAdultPrice").val("");
				$(".JS_price_selling").val("");
				 $("#branchAddPrice").val("");
				$(".JS_price_added").val("");
				$(".JS_price_settlement").val(branchAdultSettlePriceValue);
			}else if($objValue=="percent")
			{
				//比例加价时  销售价 = 结算价+百分比
				salePrice = (branchAdultSettlePriceValue * (1 + branchAddPriceValue / 100)).toFixed(2);
				$(".JS_price_percent").css("display","inline");
				$("#branchAddPrice").removeAttr("readonly");
				$("#percentClass").removeAttr("readonly");
			    $("#branchAdultPrice").attr("readonly","readonly");
				$("#JS_price_selling").attr("readonly","readonly");
				$(".JS_price_added").removeAttr("disabled").removeAttr("readonly");
				$("#branchAdultPrice").val(salePrice);
				$(".JS_price_selling").attr("readonly","readonly");
				$(".JS_price_selling").val(salePrice);
				$(".JS_price_settlement").val(branchAdultSettlePriceValue);
				$(".JS_price_added").val(branchAddPriceValue);
			}else if($objValue=="equal")
			{
				  value = $("#branchAdultSettlePrice").val();
				  $("#branchAdultPrice").val(value);
				  $(".JS_price_selling").val(value);
				  $(".JS_price_settlement").val(value);
				  $("#branchAddPrice").val("");
				  $(".JS_price_added").val("");
				  $("#branchAddPrice").attr("readonly","readonly");
				  $("#branchAdultPrice").attr("readonly","readonly");
				  $(".JS_price_percent").css("display","none");
				  $(".JS_price_added").attr("readonly","readonly");
				  $(".JS_price_selling").attr("readonly","readonly");		  
			}
		}
		function branchAddPrice(obj)
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
				$(".JS_price_rule option[value="+branchPriceType).attr("selected","select");
				$(".JS_price_percent").css("display","none");
				$(".JS_price_settlement").val(branchAdultSettlePriceValue);
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
			 
		}
		function branchAdultPrice(obj)
		{
			var $objValue = $(obj).val();
			var flag = validataData(obj, $objValue);
			if(flag==false){
				return;
				}
			$(".JS_price_selling").val($objValue);
		}
		//对批量选项进行初始化
		function initializeBranchPrice()
		{
			$("#branchModify").removeAttr("checked");
			$("#branchAdultSettlePrice").val("");
			$("#branchPriceSelect option[value=custom").attr("selected","select");
		    $("#branchAddPrice").attr("readonly","readonly");
		    $("#branchAddPrice").val("");
		    $("#branchAdultPrice").val("");
		    $("#branchAdultPrice").removeAttr("disabled").removeAttr("readonly");
		}
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
				  //如果是开售
				 $("#onSaleFlagHidden_"+goodsId).attr("checked",false);
				 $("#onSaleFlagHidden_"+goodsId).val("1");
				   $("#Set_PreSale").find("div[goodsId="+goodsId+"][class='preSaleDiv']").find("input[name='showPreSale_pre'][goods=hotel"+goodsId+"]").removeAttr("disabled");
			}else if(num==1)
			  {
			    //如果是禁售 
				  $("#onSaleFlagHidden_"+goodsId).attr("checked",true);
				  $("#onSaleFlagHidden_"+goodsId).val("1");
				    $("#Set_PreSale").find("div[goodsId="+goodsId+"][class='preSaleDiv']").find("input[name='showPreSale_pre'][goods=hotel"+goodsId+"]").attr("disabled","disabled");
					$("#Set_PreSale").find("div[goodsId="+goodsId+"][class='preSaleDiv']").find("input[name='showPreSale_pre'][goods=hotel"+goodsId+"]").val("");
			  }	
		};
		function validateForbiebutton()
		{
			var i=false;
			$("input[data='saleAble']").each(function(){
			  var goodsId = $(this).attr("goodsId");
			  if(goodsId !="" && goodsId != undefined && goodsId != "{thisGoodsId}"){
				  var value = $("#onSaleFlagHidden_"+goodsId).val();
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
		function validateModifyCheckbox()
		{
			result = true;
			var modifyCheckbox = $(".branchModify");
			 modifyCheckbox.each(function(){
				   var checkedValue = $(this).attr("checked");
				   var goodsId = $(this).attr("goodsId");
					if(checkedValue == "checked"){
						 if(goodsId !="{thisGoodsId}")
						 //结算价
						 var adultSettlePriceVal = $("#adultSettlePrice_"+goodsId).val();
						 //销售价
						 var adultPriceValue = $("#adultPrice_"+goodsId).val();
						 if(adultSettlePriceVal == "" || adultPriceValue == "") {
							  result = false;
							  alert("勾选修改的产品"+goodsId+"的价格必须填写!");
							  return false;
						}
					}else{
						//对不勾选修改的商品 价格清空
						 $("#adultSettlePrice_"+goodsId).val("");
						 $("#adultPrice_"+goodsId).val("");
						 $("#addPrice_goodsId").val("");
					}
			 }); 
			 return result;
		}
	</#if>
	
	var thisProductId='${productId}';
	var thisCategoryId = '${categoryId}';
	  //设置是否预售
  function toIsPreSale(obj,goodsId){
     var parentDiv = obj.parents('#Set_PreSale');
	// var goodsId = parentDiv.find("div.priceDiv").attr('goodsid');
	 var val = obj.val();
	 if(val=='Y'){
	 $('div.isPreSaleDiv'+goodsId).show();
	 }else{
	  $('div.isPreSaleDiv'+goodsId).hide();
	 }
  }
</script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/sales-information-edit.js"></script>

<script src="/vst_admin/js/jquery.validate.min.js"></script>
<script src="/vst_admin/js/vst_validate.js"></script>
<script src="/vst_admin/js/hotelcombSaleinfo.js"></script>
</body>
</html>
