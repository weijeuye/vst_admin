<!--用餐 START-->
<div class="module template-restaurant">

    <div class="module-head clearfix">
        <div class="module-title">用餐</div>

        <div class="module-control">
        	<a class="JS_module_prev">上移</a>
            <a class="JS_module_next">下移</a>
            <a class="JS_module_delete">删除</a>
            <a class="module-btn-edit JS_module_edit">编辑</a>
            <a class="btn btn-save JS_module_save">保存</a>
        </div>
    </div>
    <!--用餐编辑 START-->
    <div class="edit">
		<form>
		 <#-- 组隐藏域DIV -->
        <div class="JS_group_form_hidden">
        	<input type='hidden' name='productId' value="${prodLineRoute.productId}"/>
            <input type="hidden" name="routeId" />
            <input type="hidden" name="detailId" />
            <input type="hidden" name="startTime" />
            <input type="hidden" name="moduleType" value = "MEAL"/>
            <input type="hidden" name="sortValue" />
        </div>
        <div class="clearfix">
            <!--模块左侧 START-->
            <div class="module-side">
                <div class="row">
                    <div class="col module-label w70"><em>*</em>开始时间：</div>
                    <div class="col">
                        <p>
                            <span class="JS_time_input">

                            <span class="JS_time_about w20 inline-block">约</span>
                                <input type="text" class="form-control hourWidth JS_time_hour" placeholder="小时"
                                       data-validate="{required:true}" maxlength="2">
                                <span class="JS_time_blank">:</span>
                                <input type="text" class="form-control hourWidth JS_time_minute" placeholder="分钟"
                                       data-validate="{required:true}" maxlength="2">
                            </span>
                        </p>

                        <p>
                            <label class="inline-block">
                                <input name="localTimeFlag" value="Y" type="checkbox">
                                当地时间
                            </label>
                        </p>
                    </div>
                </div>
                <div class="row">
                    <div class="tip tip-warning JS_restaurant_all_day_tip none">
                        提示：当前时间为全天，请在该用餐模块录入早餐、中餐、晚餐的用餐信息
                    </div>
                </div>
            </div>
            <!--模块左侧 END-->

            <!--模块右侧 START-->
            <div class="module-main">
            	<#--用餐模块下的隐藏域DIV-->
	                <div class="JS_item_form_hidden" style="display:none">
	                     <#--用餐时间-->
	                     <input type="hidden" class="hidden_meal_time" name="prodRouteDetailMealList[0].mealTime"/>
	                     <#--早餐用餐时间-->
	                     <input type="hidden" class="hidden_breakfast_meal_time" name="prodRouteDetailMealList[0].breakfastMealTime"/>
	                     <#--午餐用餐时间-->
	                     <input type="hidden" class="hidden_lunch_meal_time" name="prodRouteDetailMealList[0].lunchMealTime"/>
	                     <#--晚餐用餐时间-->
	                     <input type="hidden" class="hidden_dinner_meal_time" name="prodRouteDetailMealList[0].dinnerMealTime"/>
	                     <#--模板CODE
         				 <input type="hidden" class="hidden_template_code" name="prodRouteDetailMealList[0].templateCode" value="" />-->
         				 <#--用餐类型-->
	                     <input type="hidden" class="hidden_meal_type" name="prodRouteDetailMealList[0].mealType"/>
	                     <#-- 用餐餐标 -->
	                     <input type="hidden" class="hidden_meal_price" name="prodRouteDetailMealList[0].price"/>
	                     <#-- 早餐用餐餐标 -->
	                     <input type="hidden" class="hidden_breakfast_meal_price" name="prodRouteDetailMealList[0].breakfastPrice"/>
	                     <#-- 午餐用餐餐标 -->
	                     <input type="hidden" class="hidden_lunch_meal_price" name="prodRouteDetailMealList[0].lunchPrice"/>
	                     <#-- 晚餐用餐餐标 -->
	                     <input type="hidden" class="hidden_dinner_meal_price" name="prodRouteDetailMealList[0].dinnerPrice"/>
	                      <#--存储不为“全天”的货币类型-->
	                     <input type="hidden" class="hidden_meal_currency" name="prodRouteDetailMealList[0].currency"/>
	                     <#--早餐货币类型-->
	                     <input type="hidden" class="hidden_breakfastMeal_currency"  name="prodRouteDetailMealList[0].breakfastCurrency"/>
	                     <#--中餐货币类型-->
	                     <input type="hidden" class="hidden_lunchMeal_currency"  name="prodRouteDetailMealList[0].lunchCurrency"/>
	                     <#--晚餐货币类型-->
	                     <input type="hidden" class="hidden_dinnerMeal_currency"  name="prodRouteDetailMealList[0].dinnerCurrency"/>
	                     
	                </div>
                <div class="row JS_restaurant_type state-single">
                    <div class="col w70 module-label">
                        <em>*</em> 用餐类型：
                    </div>
                    <div class="col JS_restaurant_type_single">
                        <select class="form-control w80" data-validate="{required:true}">
                            <option value="">选择类型</option>
                            <option value="BREAKFAST">早餐</option>
                            <option value="LUNCH">中餐</option>
                            <option value="DINNER">晚餐</option>
                            <option value="SELF_BREAKFAST">早餐自理</option>
                            <option value="SELF_LUNCH">中餐自理</option>
                            <option value="SELF_DINNER">晚餐自理</option>
                        </select>
                    </div>
                    <div class="col JS_restaurant_type_multiple">
                        <select class="multiple-select" multiple="multiple" data-placeholder="选择类型" disabled data-validate="{required:true}">
                            <option value="BREAKFAST" data-unique="1">早餐</option>
                            <option value="LUNCH" data-unique="2">中餐</option>
                            <option value="DINNER" data-unique="3">晚餐</option>
                            <option value="SELF_BREAKFAST" data-unique="1">早餐自理</option>
                            <option value="SELF_LUNCH" data-unique="2">中餐自理</option>
                            <option value="SELF_DINNER" data-unique="3">晚餐自理</option>
                        </select>
                    </div>
                </div>
                <#--开始时间  不为“全天”-->
                <div class="JS_switch_noallday">
	                <div class="row">
	                    <div class="col w70 module-label">
	                        用餐时间：
	                    </div>
	                    <div class="col">
	                        约
	                        <input type="text" class="form-control w40 JS_meal_hour" data-validate="{regular:true}"
	                               data-validate-regular="^\d*$" maxlength="2"/>
	                        小时
	                        <input type="text" class="form-control w40 JS_meal_minute" data-validate="{regular:true}"
	                               data-validate-regular="^\d*$" maxlength="2"/>
	                        分钟；
	                    </div>
	                </div>
	                <div class="row">
	                    <div class="col w70 module-label">
	                        餐费标准：
	                    </div>
	                    <div class="col">
	                        <input type="text" class="form-control w70 JS_meal_price" data-validate="{regular:true}"
	                               data-validate-regular="^\d*$" maxlength="5"/>
	                        <select class="form-control w70 JS_meal_currency">
	                            <#list currencys as currency>
			                        <option value="${currency.name()!''}">${currency.cnName!''}</option>
			                    </#list>
	                        </select>
	                        /人/餐
	                    </div>
	                </div>
                </div>
                
                <#--开始时间  为“全天”-->
                <div class="JS_switch_allday"  style="display:none">
                <div class="row">
                    <div class="col w70 module-label">
	                        用餐时间：
	                </div>
	                <div class="col">
	                       早餐    约
                        <input type="text" class="form-control w40 JS_breakfast_meal_hour"  data-validate="{regular:true}"
                               data-validate-regular="^\d*$" maxlength="2"/>
                                小时
                        <input type="text" class="form-control w40 JS_breakfast_meal_minute" data-validate="{regular:true}" 
                               data-validate-regular="^\d*$" maxlength="2"/>
                                分钟；
	                </div>
                </div>
                <div class="row">
                    <div class="col w70 module-label">
	                        
	                </div>
	                <div class="col">
	                   中餐    约
	                    <input type="text" class="form-control w40 JS_lunch_meal_hour"  data-validate="{regular:true}"
	                           data-validate-regular="^\d*$" maxlength="2"/>
	                    小时
	                    <input type="text" class="form-control w40 JS_lunch_meal_minute"  data-validate="{regular:true}"
	                           data-validate-regular="^\d*$" maxlength="2"/>
	                    分钟；
	                </div>
                </div>
                <div class="row">
                    <div class="col w70 module-label">
	                        
	                </div>
	                <div class="col">
                       晚餐    约
                        <input type="text" class="form-control w40 JS_dinner_meal_hour"  data-validate="{regular:true}"
                               data-validate-regular="^\d*$" maxlength="2"/>
                        小时
                        <input type="text" class="form-control w40 JS_dinner_meal_minute"  data-validate="{regular:true}"
                               data-validate-regular="^\d*$" maxlength="2"/>
                        分钟；
                    </div>
	            </div> 
	            <div class="row">
	                    <div class="col w70 module-label">
	                        餐费标准：
	                    </div>
	                    <div class="col">
	                       早餐  
	                      <input type="text" class="form-control w85 JS_breakfast_meal_price" data-validate="{regular:true}"data-validate-regular="^\d*$" maxlength="5"/>
	                        <select class="form-control w85 JS_select_switch_breakfast">
	                            <#list currencys as currency>
			                        <option value="${currency.name()!''}">${currency.cnName!''}</option>
			                    </#list>
	                        </select>
	                        /人/餐
	                    </div>   
	            </div> 
	            <div class="row">
	            	<div class="col w70 module-label">
	                        
	                 </div>
                    <div class="col">
                        <span class="lunchname" >中餐   </span> 
                        <input type="text" class="form-control w85 JS_lunch_meal_price" data-validate="{regular:true}"data-validate-regular="^\d*$" maxlength="5"/>
                        <select class="form-control w85 JS_select_switch_lunch">
                            <#list currencys as currency>
		                        <option value="${currency.name()!''}">${currency.cnName!''}</option>
		                    </#list>
                        </select>
                        /人/餐
                    </div>
	            </div>
	            <div class="row">
	            	<div class="col w70 module-label">
	                        
                    </div>
                    <div class="col">
                       <span class="dinnername" > 晚餐 </span>  <input type="text" class="form-control w85 JS_dinner_meal_price" data-validate="{regular:true}"
                               data-validate-regular="^\d*$" maxlength="5"/>
                        <select class="form-control w85 JS_select_switch_dinner">
                            <#list currencys as currency>
		                        <option value="${currency.name()!''}">${currency.cnName!''}</option>
		                    </#list>
                        </select>
                        /人/餐
                    </div>
	            </div> 
	            </div> 
                <div class="row JS_radio_switch_group">
                    <div class="col w70 module-label">
                        用餐地点：
                    </div>
                    <div class="col">
                        <span class="JS_radio_switch_box">
                            <label>
                                <input type="radio" class="JS_radio_switch" name="prodRouteDetailMealList[0].mealPlace" value="1"/>
                                酒店内
                            </label>
                        </span>
                        <span class="JS_radio_switch_box">
                            <input type="radio" class="JS_radio_switch" name="prodRouteDetailMealList[0].mealPlace" value="2"/>
                            <input type="text" class="form-control w250 JS_radio_disabled" disabled="disabled" name="prodRouteDetailMealList[0].mealPlaceOther"
                                   placeholder="输入其他用餐地点" maxlength="50"/>
                        </span>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col w90 module-label">
                        话术模板 <i class="icon icon-help" data-poptip="话术模板可以将你所填的内容整合成较为易懂的一段话"></i> ：
                    </div>
                    <div class="col">
                        <label>
                            <input type="checkbox" name="prodRouteDetailMealList[0].useTemplateFlag" value="Y"/>
                            使用系统提供的话术模板来显示信息
                        </label>
                        <a class="JS_restaurant_preview">预览查看</a>
                    </div>
                </div>
                <div class="row">
                    <div class="col w70 module-label">
                        用餐说明：
                    </div>
                    <div class="col">
                        <div class="col JS_textares_box">
                            <a class="textarea-content-expand JS_textarea_expand"
                               data-text="展开用餐说明 <i class='triangle'></i>">
                                添加用餐说明
                                <i class="triangle"></i>
                            </a>

                            <div>
                                <textarea class="form-control textarea-content" maxlength="500" name="prodRouteDetailMealList[0].mealDesc"></textarea>
                            </div>

                            <a class="textarea-content-shrink JS_textarea_shrink">
                                收起用餐说明
                                <i class="triangle"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <!--模块右侧 END-->
        </div>
	</form>
    </div>
    <!--用餐编辑 END-->
    <div class="day-module-add">
        <div class="day-module-add-title">添加行程信息 <i class="triangle"></i></div>
    </div>
</div>
<!--用餐 END-->
