<#--定义是否为新结构标记变量-->
<#assign newStructureFlag = (prodLineRoute?? && prodLineRoute.newStructureFlag == "N")?string("N","Y") />

<#if routeDetailGroup.prodRouteDetailMealList?? && routeDetailGroup.prodRouteDetailMealList?size &gt; 0>
    <#assign prodRouteDetailMeal = routeDetailGroup.prodRouteDetailMealList[0] />
<#else>
    <#assign prodRouteDetailMeal = prodRouteDetailMealEmpty />
</#if>
<#--用餐 START-->
    <div class="module template-restaurant <#if newStructureFlag == "Y">state-view<#else>state-edit</#if>" data-id="${routeDetailGroup.groupId}">

        <div class="module-head clearfix">
            <div class="module-title">用餐</div>

            <div class="module-control">
            	<a class="JS_module_prev">上移</a>
            	<a class="JS_module_next">下移</a>
                <a class="JS_module_delete">删除</a>
                <a class="module-btn-edit JS_module_edit">编辑</a>
                <#if newStructureFlag == "Y">
                <a class="btn btn-save JS_module_save">保存</a>
                </#if>
            </div>
        </div>

        <!--用餐查看 START-->
        <div class="view">

            <div class="module-post clearfix">
				<#assign mealTypeCnName = routeDetailFormat.getMealTypeCnName(prodRouteDetailMeal.mealType)!'' />
				<#assign mealTimeFormat = routeDetailFormat.getTimeStr(prodRouteDetailMeal.mealTime)!'' />
				

                <#assign mealPriceFormat = routeDetailFormat.getCnPriceFormat(prodRouteDetailMeal.price, prodRouteDetailMeal.currency, 'MEAL')!'' />
                
                
                <div class="module-post-left">
                    <p>${routeDetailGroup.getTimeType()!''}</p>
                <#if routeDetailGroup.localTimeFlag =="Y"><p class="text-gray module-local-time">当地时间</p></#if>
                </div>
                <div class="module-post-right">
                    <div class="module-post-content">
	                <#if prodRouteDetailMeal.useTemplateFlag == "Y">
	                <i class="icon-state icon-state-restaurant"></i>
	                <div class="view-content-new">
						<div class="row">
							${prodRouteDetailMeal.templateText!''?replace("\n", "<br/>")}
						</div>
					 </div>
	                <#else>
		  <i class="icon-state icon-state-restaurant"></i>
                    <h3>
                        ${mealTypeCnName!''}
                    </h3>
                    
                    <div class="view-content-new">
                    <#if routeDetailGroup.getTimeType() == "全天">
                        
                        <#assign breakfastMealTimeFormat = routeDetailFormat.getTimeStr(prodRouteDetailMeal.breakfastMealTime)!'' />
				        <#assign lunchMealTimeFormat = routeDetailFormat.getTimeStr(prodRouteDetailMeal.lunchMealTime)!'' />
				        <#assign dinnerMealTimeFormat = routeDetailFormat.getTimeStr(prodRouteDetailMeal.dinnerMealTime)!'' />
				        
				        <#assign breakfastMealPriceFormat = routeDetailFormat.getCnPriceFormat(prodRouteDetailMeal.breakfastPrice, prodRouteDetailMeal.breakfastCurrency, 'MEAL')!'' />
                        <#assign lunchMealPriceFormat = routeDetailFormat.getCnPriceFormat(prodRouteDetailMeal.lunchPrice, prodRouteDetailMeal.lunchCurrency, 'MEAL')!'' />
                        <#assign dinnerMealPriceFormat = routeDetailFormat.getCnPriceFormat(prodRouteDetailMeal.dinnerPrice, prodRouteDetailMeal.dinnerCurrency, 'MEAL')!'' />
                        <#--结构化后的数据-->
                        <#if (prodRouteDetailMeal.breakfastMealTime?? && prodRouteDetailMeal.breakfastMealTime !="") || (prodRouteDetailMeal.lunchMealTime?? && prodRouteDetailMeal.lunchMealTime !="") || (prodRouteDetailMeal.dinnerMealTime?? && prodRouteDetailMeal.dinnerMealTime !="") || (prodRouteDetailMeal.mealTime?? && prodRouteDetailMeal.mealTime !="")>
                        <div class="row">
                            <div class="col w65">
                            用餐时间：
                            </div>
                            <#if prodRouteDetailMeal.breakfastMealTime?? && prodRouteDetailMeal.breakfastMealTime !="">
                            <div class="col w700">
                             早餐   ${breakfastMealTimeFormat!''}
                            </div>
                            <#else>
                            <#if prodRouteDetailMeal.mealTime?? && prodRouteDetailMeal.mealTime !="">
                            <div class="col w700">
                             早餐   ${mealTimeFormat!''}
                            </div>
                            </#if>
                            </#if>
                            <#if prodRouteDetailMeal.lunchMealTime?? && prodRouteDetailMeal.lunchMealTime !="">
                            <div class="col w700">
                             中餐   ${lunchMealTimeFormat!''}
                            </div>
                            <#else>
                            <#if prodRouteDetailMeal.mealTime?? && prodRouteDetailMeal.mealTime !="">
                            <div class="col w700">
                             中餐   ${mealTimeFormat!''}
                            </div>
                            </#if>
                            </#if>
                            <#if prodRouteDetailMeal.dinnerMealTime?? && prodRouteDetailMeal.dinnerMealTime !="">
                            <div class="col w700">
                             晚餐   ${dinnerMealTimeFormat!''}
                            </div>
                            <#else>
                            <#if prodRouteDetailMeal.mealTime?? && prodRouteDetailMeal.mealTime !="">
                            <div class="col w700">
                             晚餐   ${mealTimeFormat!''}
                            </div>
                            </#if>
                            </#if>
                        </div>
                        </#if>
                        <#if (prodRouteDetailMeal.breakfastPrice?? && prodRouteDetailMeal.breakfastPrice != 0) || (prodRouteDetailMeal.lunchPrice?? && prodRouteDetailMeal.lunchPrice != 0) || (prodRouteDetailMeal.dinnerPrice?? && prodRouteDetailMeal.dinnerPrice != 0) || (prodRouteDetailMeal.price?? && prodRouteDetailMeal.price != 0)>
                        <div class="row">
                            <div class="col w65">
                            餐费标准：
                            </div>
                            <#if prodRouteDetailMeal.breakfastPrice?? && prodRouteDetailMeal.breakfastPrice != 0>
                            <div class="col w700">
                            早餐   ${breakfastMealPriceFormat!''}/人/餐
                            </div>
                            <#else>
                            <#if prodRouteDetailMeal.price?? && prodRouteDetailMeal.price != 0>
                            <div class="col w700">
                            早餐   ${mealPriceFormat!''}/人/餐
                            </div>
                            </#if>
                            </#if>
                            <#if prodRouteDetailMeal.lunchPrice?? && prodRouteDetailMeal.lunchPrice != 0>
                            <div class="col w700">
                            中餐   ${lunchMealPriceFormat!''}/人/餐
                            </div>
                            <#else>
                            <#if prodRouteDetailMeal.price?? && prodRouteDetailMeal.price != 0>
                            <div class="col w700">
                            中餐   ${mealPriceFormat!''}/人/餐
                            </div>
                            </#if>
                            </#if>
                            <#if prodRouteDetailMeal.dinnerPrice?? && prodRouteDetailMeal.dinnerPrice != 0>
                            <div class="col w700">
                            晚餐   ${dinnerMealPriceFormat!''}/人/餐
                            </div>
                            <#else>
                            <#if prodRouteDetailMeal.price?? && prodRouteDetailMeal.price != 0>
                            <div class="col w700">
                            晚餐   ${mealPriceFormat!''}/人/餐
                            </div>
                            </#if>
                            </#if>
		                </div>
                        </#if>
                    <#else>
                    	<#if prodRouteDetailMeal.mealTime??>
                        <div class="row">
                         <div class="col w65">
                            用餐时间：
                            </div>
                         <div class="col w700">
                             ${mealTimeFormat!''}
                            </div>
                        </div>
                        </#if>
                        <#if prodRouteDetailMeal.price?? && prodRouteDetailMeal.price != 0>
                        <div class="row">
                         <div class="col w65">
                            餐费标准：
                            </div>
                         <div class="col w700">
                            ${mealPriceFormat!''}/人/餐
                            </div>
		     </div>
                        </#if>
                    </#if>
                         <#if prodRouteDetailMeal.mealPlace == 1>
		                    <#assign mealPlace = "酒店内"/>
		                <#else>
		                    <#assign mealPlace = prodRouteDetailMeal.mealPlaceOther/>
		                </#if>
		                <#if mealPlace!''>
		        <div class="row">
                         <div class="col w65">
                           用餐地点：
                         </div>
			             <div class="col w700">
                            ${mealPlace}
                         </div>
		        </div>
                        </#if>
                        <#if prodRouteDetailMeal.mealDesc!''>
                        <div class="row">
                            ${prodRouteDetailMeal.mealDesc?replace("\n", "<br/>")!''}
                        </div>
		     
                        </#if>
                    </div>
                    
                    </#if>
                    </div>
                </div>

            </div>
        </div>
        <!--用餐查看 END-->

        <!--用餐编辑 START-->
        <div class="edit">
       <form>
	           <#-- 组隐藏域DIV -->
	        <div class="JS_group_form_hidden">
	        	<#--产品ID-->
	            <input type="hidden" name="productId" value="${routeDetailGroup.productId}" />
	            <#--行程ID-->
	            <input type="hidden" name="routeId" value="${routeDetailGroup.routeId}" />
	            <#--行程明细ID-->
	            <input type="hidden" name="detailId" value="${routeDetailGroup.detailId}" />
	            <#--产品ID-->
	            <input type="hidden" name="groupId" value="${routeDetailGroup.groupId}" />
	            <#--开始时间-->
	            <input type="hidden" name="startTime" value="${routeDetailGroup.startTime}" />
	            <#--模块类型-->
	            <input type="hidden" name="moduleType" value="MEAL"/>
	            <input type="hidden" name="sortValue" value="${routeDetailGroup.sortValue}"/>
	        </div>

            <div class="clearfix">
                <!--模块左侧 START-->
                <div class="module-side">
                <#-- 组的开始时间-->
                <#if routeDetailGroup.startTime?? && routeDetailGroup.startTime?contains(":")>
                    <#assign hasColon = "Y"/>
                    <#assign startTime = routeDetailGroup.startTime?split(":")/>
                <#else>
                    <#assign hasColon = "N"/>
                </#if>
                    <div class="row">
                        <div class="col module-label w70"><em>*</em>开始时间：</div>
                        <div class="col">
                            <p>
                                <span class="JS_time_input">

                                <span class="JS_time_about w20 inline-block">约</span>
                                    <input type="text" class="form-control hourWidth JS_time_hour" value="<#if hasColon == "Y">${startTime[0]!''}<#else>${routeDetailGroup.getTimeType()!''}</#if>" placeholder="小时"
                                           data-validate="{required:true}" maxlength="2">
                                    <span class="JS_time_blank" <#if hasColon == "N">style="display:none;"</#if> >:</span>
                                    <input type="text" class="form-control w30 JS_time_minute" <#if hasColon == "N">disabled style="display:none;"</#if> value="<#if hasColon == "Y">${startTime[1]!''}</#if>" placeholder="分钟"
                                           data-validate="{required:true}" maxlength="2">
                                </span>
                            </p>

                            <p>
                                <label class="inline-block">
                                    <input type="checkbox" name="localTimeFlag" value="Y" <#if routeDetailGroup.localTimeFlag=="Y">checked="checked"</#if>>
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
	                     <input type="hidden" class="hidden_meal_time" name="prodRouteDetailMealList[0].mealTime" value="${prodRouteDetailMeal.mealTime}"/>
	                     <#--早餐用餐时间-->
	                     <input type="hidden" class="hidden_breakfast_meal_time" name="prodRouteDetailMealList[0].breakfastMealTime" value="${prodRouteDetailMeal.breakfastMealTime}"/>
	                     <#--午餐用餐时间-->
	                     <input type="hidden" class="hidden_lunch_meal_time" name="prodRouteDetailMealList[0].lunchMealTime" value="${prodRouteDetailMeal.lunchMealTime}"/>
	                     <#--晚餐用餐时间-->
	                     <input type="hidden" class="hidden_dinner_meal_time" name="prodRouteDetailMealList[0].dinnerMealTime" value="${prodRouteDetailMeal.dinnerMealTime}"/>
	                     <#--用餐类型-->
	                     <input type="hidden" class="hidden_meal_type" name="prodRouteDetailMealList[0].mealType"/>
	                     <#--用餐ID-->
	                     <input type="hidden" class="hidden_meal_mealId" name="prodRouteDetailMealList[0].mealId"  value="${prodRouteDetailMeal.mealId}"/>
	                     <#--Group ID-->
	                     <input type="hidden" class="hidden_meal_groupId" name="prodRouteDetailMealList[0].groupId"  value="${prodRouteDetailMeal.groupId}"/>
	                     <#--Detail ID-->
	                     <input type="hidden" class="hidden_meal_detailId" name="prodRouteDetailMealList[0].detailId"  value="${prodRouteDetailMeal.detailId}"/>
	                     <#-- 用餐餐标 -->
	                     <input type="hidden" class="hidden_meal_price" name="prodRouteDetailMealList[0].price"  value="${prodRouteDetailMeal.price!''}"/>
	                     <#-- 早餐用餐餐标 -->
	                     <input type="hidden" class="hidden_breakfast_meal_price" name="prodRouteDetailMealList[0].breakfastPrice" value="${prodRouteDetailMeal.breakfastPrice!''}"/>
	                     <#-- 午餐用餐餐标 -->
	                     <input type="hidden" class="hidden_lunch_meal_price" name="prodRouteDetailMealList[0].lunchPrice" value="${prodRouteDetailMeal.lunchPrice!''}"/>
	                     <#-- 晚餐用餐餐标 -->
	                     <input type="hidden" class="hidden_dinner_meal_price" name="prodRouteDetailMealList[0].dinnerPrice" value="${prodRouteDetailMeal.dinnerPrice!''}"/>
	                     <#--存储不为“全天”的货币类型-->
	                     <input type="hidden" class="hidden_meal_currency"  value="${prodRouteDetailMeal.currency!''}"/>
	                     <#--早餐货币类型-->
	                     <input type="hidden" class="hidden_breakfastMeal_currency"  name="prodRouteDetailMealList[0].breakfastCurrency" value="${prodRouteDetailMeal.breakfastCurrency!''}"/>
	                     <#--中餐货币类型-->
	                     <input type="hidden" class="hidden_lunchMeal_currency"  name="prodRouteDetailMealList[0].lunchCurrency" value="${prodRouteDetailMeal.lunchCurrency!''}"/>
	                     <#--晚餐货币类型-->
	                     <input type="hidden" class="hidden_dinnerMeal_currency"  name="prodRouteDetailMealList[0].dinnerCurrency" value="${prodRouteDetailMeal.dinnerCurrency!''}"/>
	                     
	                </div>
	                <#assign isMultiple = prodRouteDetailMeal.mealType?index_of("|") != -1 || routeDetailGroup.startTime == "ALL_DAY"/>
                    <div class="row JS_restaurant_type <#if isMultiple>state-multiple<#else>state-single</#if>">
                        <div class="col w70 module-label">
                       		<em>*</em>用餐类型：
                        </div>
                        <div class="col JS_restaurant_type_multiple">
                        	<#assign mealTypes = "|" + prodRouteDetailMeal.mealType + "|"/>
                        	<select class="multiple-select" multiple="multiple" <#if !isMultiple>disabled</#if> data-validate="{required:true}" <#if !isMultiple>disabled</#if> data-placeholder="选择类型">
                                <option value="BREAKFAST" data-unique="1" <#if mealTypes?contains("|BREAKFAST|")>selected</#if>>早餐</option>
                                <option value="LUNCH" data-unique="2" <#if mealTypes?contains("|LUNCH|")>selected</#if>>中餐</option>
                                <option value="DINNER" data-unique="3" <#if mealTypes?contains("|DINNER|")>selected</#if>>晚餐</option>
                                <option value="SELF_BREAKFAST" data-unique="1" <#if mealTypes?contains("|SELF_BREAKFAST|")>selected</#if>>早餐自理</option>
                                <option value="SELF_LUNCH" data-unique="2" <#if mealTypes?contains("|SELF_LUNCH|")>selected</#if>>中餐自理</option>
                                <option value="SELF_DINNER" data-unique="3" <#if mealTypes?contains("|SELF_DINNER|")>selected</#if>>晚餐自理</option>
                            </select>
                        </div>
                        <div class="col JS_restaurant_type_single">
                        	<select class="form-control w80" <#if isMultiple>disabled</#if> data-validate="{required:true}">
                                <option value="">选择类型</option>
                                <option value="BREAKFAST" <#if prodRouteDetailMeal.mealType=="BREAKFAST">selected</#if>>早餐</option>
                                <option value="LUNCH" <#if prodRouteDetailMeal.mealType=="LUNCH">selected</#if>>中餐</option>
                                <option value="DINNER" <#if prodRouteDetailMeal.mealType=="DINNER">selected</#if>>晚餐</option>
                                <option value="SELF_BREAKFAST" <#if prodRouteDetailMeal.mealType=="SELF_BREAKFAST">selected</#if>>早餐自理</option>
                                <option value="SELF_LUNCH" <#if prodRouteDetailMeal.mealType=="SELF_LUNCH">selected</#if>>中餐自理</option>
                                <option value="SELF_DINNER" <#if prodRouteDetailMeal.mealType=="SELF_DINNER">selected</#if>>晚餐自理</option>
                            </select>
                        </div>
                    </div>
                    
                    
                    
                    
                <#-- 用餐时间 -->
		                <#if prodRouteDetailMeal.mealTime?? && prodRouteDetailMeal.mealTime != null>
		                    <#assign mealTime = prodRouteDetailMeal.mealTime?split(":")/>
		                <#else>
		                    <#assign mealTime = ['','']/>
		                </#if>
		                
		                <#if prodRouteDetailMeal.breakfastMealTime?? && prodRouteDetailMeal.breakfastMealTime != null>
		                    <#assign breakfastMealTime = prodRouteDetailMeal.breakfastMealTime?split(":")/>
		                <#else>
		                    <#assign breakfastMealTime = ['','']/>
		                </#if>   
		                
		                <#if prodRouteDetailMeal.lunchMealTime?? && prodRouteDetailMeal.lunchMealTime != null>
		                    <#assign lunchMealTime = prodRouteDetailMeal.lunchMealTime?split(":")/>
		                <#else>
		                    <#assign lunchMealTime = ['','']/>
		                </#if>   
		                
		                <#if prodRouteDetailMeal.dinnerMealTime?? && prodRouteDetailMeal.dinnerMealTime != null>
		                    <#assign dinnerMealTime = prodRouteDetailMeal.dinnerMealTime?split(":")/>
		                <#else>
		                    <#assign dinnerMealTime = ['','']/>
		                </#if>
		                <input type="hidden" id="categoryId" name="categoryId" value="${categoryId!''}"/>
		                      
                <#--开始时间  不为“全天”-->
                 <div class="JS_switch_noallday" style="display:none">
                    <div class="row">
                        <div class="col w70 module-label">
                            用餐时间：
                        </div>
                        
                        <div class="col">
                            约
                            <input type="text" class="form-control w40 JS_meal_hour" data-validate="{regular:true}"
                                   data-validate-regular="^\d*$" maxlength="2" value="${mealTime[0]!''}"/>
                            小时
                            <input type="text" class="form-control w40 JS_meal_minute" data-validate="{regular:true}"
                                   data-validate-regular="^\d*$" maxlength="2" value="${mealTime[1]!''}" />
                            分钟
                        </div>
                    </div>
                    <div class="row">
                        <div class="col w70 module-label">
                        
                        <#if productType!="FOREIGNLINE" && categoryId!=18 && (prodRouteDetailMeal.mealType=="LUNCH"||prodRouteDetailMeal.mealType=="DINNER")><em>*</em></#if>
                            餐费标准：
                        </div>
                        <div class="col">
                            <input type="text" class="form-control w70 JS_meal_price" value="${routeDetailFormat.formatPrice(prodRouteDetailMeal.price)!''}"
                            <#if productType!="FOREIGNLINE" && categoryId!=18 && (prodRouteDetailMeal.mealType=="LUNCH"||prodRouteDetailMeal.mealType=="DINNER")>
                             data-validate="{required:true,regular:true}"
                            <#else>
                            	data-validate="{regular:true}"
                            </#if>
                              data-validate-regular="^\d*$" maxlength="5"/>
                            <select class="form-control w70" name="prodRouteDetailMealList[0].currency">
                                <#list currencys as currency>
                                    <option value="${currency.name()!''}" <#if currency.name()==prodRouteDetailMeal.currency>selected</#if> >${currency.cnName!''}</option>
                                </#list>
                            </select>
                            /人/餐
                        </div>
                    </div>
                 </div>

                 <#--开始时间  不为“全天”  结束-->
                    
                 <#--开始时间  为“全天”  开始-->
                 <div class="JS_switch_allday"  style="display:none">
	                 <div class="row">
	                 	<div class="col w70 module-label">
	                        用餐时间：
	                    </div>
	                    <div class="col">
	                       早餐    约
	                        <#if breakfastMealTime[0]?? && breakfastMealTime[0]!=''>
	                        <input type="text" class="form-control w40 JS_breakfast_meal_hour" data-validate="{regular:true}" value="${breakfastMealTime[0]!''}" data-validate-regular="^\d*$" maxlength="2"/>
	                        <#else>
	                        <input type="text" class="form-control w40 JS_breakfast_meal_hour" data-validate="{regular:true}" value="${mealTime[0]!''}" data-validate-regular="^\d*$" maxlength="2"/>
	                        </#if>
	               小时
	                        <#if breakfastMealTime[1]?? && breakfastMealTime[1]!=''>
	                        <input type="text" class="form-control w40 JS_breakfast_meal_minute" data-validate="{regular:true}" value="${breakfastMealTime[1]!''}" data-validate-regular="^\d*$" maxlength="2"/>
	                        <#else>
	                        <input type="text" class="form-control w40 JS_breakfast_meal_minute" data-validate="{regular:true}" value="${mealTime[1]!''}" data-validate-regular="^\d*$" maxlength="2"/>
	                        </#if>       
	                        分钟；
	                    </div>
	                 </div>
	                 <div class="row">
	                 	<div class="col w70 module-label">
	                        
	                    </div>
	                    <div class="col">
	                       中餐    约
	                        <#if lunchMealTime[0]?? && lunchMealTime[0]!=''>
	                        <input type="text" class="form-control w40 JS_lunch_meal_hour" data-validate="{regular:true}" value="${lunchMealTime[0]!''}" data-validate-regular="^\d*$" maxlength="2"/>
	                        <#else>
	                        <input type="text" class="form-control w40 JS_lunch_meal_hour" data-validate="{regular:true}" value="${mealTime[0]!''}" data-validate-regular="^\d*$" maxlength="2"/>
	                        </#if>
	                          小时
	                        <#if lunchMealTime[1]?? && lunchMealTime[1]!=''>
	                        <input type="text" class="form-control w40 JS_lunch_meal_minute" data-validate="{regular:true}"  value="${lunchMealTime[1]!''}" data-validate-regular="^\d*$" maxlength="2"/>
	                        <#else>
	                        <input type="text" class="form-control w40 JS_lunch_meal_minute"  data-validate="{regular:true}" value="${mealTime[1]!''}" data-validate-regular="^\d*$" maxlength="2"/>
	                        </#if>
	                        分钟；
	                    </div>
	                 </div>
	                 <div class="row">
	                 	<div class="col w70 module-label">
	                        
	                    </div>
	                    <div class="col">
	                       晚餐    约
	                        <#if dinnerMealTime[0]?? && dinnerMealTime[0]!=''>
	                        <input type="text" class="form-control w40 JS_dinner_meal_hour" data-validate="{regular:true}" value="${dinnerMealTime[0]!''}" data-validate-regular="^\d*$" maxlength="2"/>
	                        <#else>
	                        <input type="text" class="form-control w40 JS_dinner_meal_hour" data-validate="{regular:true}" value="${mealTime[0]!''}" data-validate-regular="^\d*$" maxlength="2"/>
	                        </#if>
	                          小时
	                        <#if dinnerMealTime[1]?? && dinnerMealTime[1]!=''>
	                        <input type="text" class="form-control w40 JS_dinner_meal_minute" data-validate="{regular:true}" value="${dinnerMealTime[1]!''}" data-validate-regular="^\d*$" maxlength="2"/>
	                        <#else>
	                        <input type="text" class="form-control w40 JS_dinner_meal_minute" data-validate="{regular:true}" value="${mealTime[1]!''}" data-validate-regular="^\d*$" maxlength="2"/>
	                        </#if>
	                        分钟；
	                    </div>
	                 </div>
	                 <div class="row">
	                 	<div class="col w70 module-label">
	                        餐费标准：
	                    </div>
	                    <div class="col">
	                                      早餐  </span>  
                       <#if prodRouteDetailMeal.breakfastPrice?? && prodRouteDetailMeal.breakfastPrice !=0>
	                    <input type="text" class="form-control w85 JS_breakfast_meal_price" data-validate="{regular:true}" 
	                    value="${routeDetailFormat.formatPrice(prodRouteDetailMeal.breakfastPrice)!''}" data-validate-regular="^\d*$" maxlength="5"/>
	                    <#else>
	                    <input type="text" class="form-control w85 JS_breakfast_meal_price" 
	                    data-validate="{regular:true}"
						value="${routeDetailFormat.formatPrice(prodRouteDetailMeal.price)!''}" data-validate-regular="^\d*$" maxlength="5"/>
	                    </#if>
	                        <select class="form-control w85 JS_select_switch_breakfast" >
	                            <#list currencys as currency>
	                                <#if prodRouteDetailMeal.breakfastCurrency??>
			                        <option value="${currency.name()!''}"<#if currency.name()==prodRouteDetailMeal.breakfastCurrency>selected</#if>>${currency.cnName!''}</option>
			                        <#else>
			                        <option value="${currency.name()!''}"<#if currency.name()==prodRouteDetailMeal.currency>selected</#if>>${currency.cnName!''}</option>
			                        </#if>
			                    </#list>
	                        </select>
	                        /人/餐
	                    </div>
	                 </div>
	                 <div class="row">
	                 	<div class="col w70 module-label">
	                        
	                    </div>
	                    <div class="col">
	                                      <span class="lunchname" ><#if productType!="FOREIGNLINE" && categoryId!=18 && (prodRouteDetailMeal.mealType?contains("LUNCH")&& !prodRouteDetailMeal.mealType?contains("SELF_LUNCH"))><em style='color:#FF0000'>*</em></#if>
	                                      中餐   </span>  <#if prodRouteDetailMeal.lunchPrice?? && prodRouteDetailMeal.lunchPrice !=0>
	                    <input type="text" class="form-control w85 JS_lunch_meal_price" 
	                    <#if productType!="FOREIGNLINE" && categoryId!=18 && (prodRouteDetailMeal.mealType?contains("LUNCH")&& !prodRouteDetailMeal.mealType?contains("SELF_LUNCH"))> 
	                    data-validate="{required:true,regular:true}"
	                    <#else>data-validate="{regular:true}" </#if>
	                    value="${routeDetailFormat.formatPrice(prodRouteDetailMeal.lunchPrice)!''}" data-validate-regular="^\d*$" maxlength="5"/>
	                    <#else>
	                    <input type="text" class="form-control w85 JS_lunch_meal_price" 
	                    <#if productType!="FOREIGNLINE" && categoryId!=18 && (prodRouteDetailMeal.mealType?contains("LUNCH")&& !prodRouteDetailMeal.mealType?contains("SELF_LUNCH"))>
	                     data-validate="{required:true,regular:true}"
	                    <#else>data-validate="{regular:true}" </#if>
	                    value="${routeDetailFormat.formatPrice(prodRouteDetailMeal.price)!''}" data-validate-regular="^\d*$" maxlength="5"/>
	                    </#if>
	                        <select class="form-control w85 JS_select_switch_lunch" >
	                            <#list currencys as currency>
			                        <#if prodRouteDetailMeal.breakfastCurrency??>
			                        <option value="${currency.name()!''}"<#if currency.name()==prodRouteDetailMeal.lunchCurrency>selected</#if>>${currency.cnName!''}</option>
			                        <#else>
			                        <option value="${currency.name()!''}"<#if currency.name()==prodRouteDetailMeal.currency>selected</#if>>${currency.cnName!''}</option>
			                        </#if>
			                    </#list>
	                        </select>
	                        /人/餐
	                    </div>
	                 </div>
	                 <div class="row">
	                 	<div class="col w70 module-label">
	                        
	                    </div>
	                    <div class="col">
	                                     <span class="dinnername" ><#if productType!="FOREIGNLINE" && categoryId!=18 && (prodRouteDetailMeal.mealType?contains("DINNER")&& !prodRouteDetailMeal.mealType?contains("SELF_DINNER"))><em style='color:#FF0000'>*</em></#if>
	                                      晚餐 </span>   <#if prodRouteDetailMeal.dinnerPrice?? && prodRouteDetailMeal.dinnerPrice !=0>
	                    <input type="text" class="form-control w85 JS_dinner_meal_price" 
	                    <#if productType!="FOREIGNLINE" && categoryId!=18 && (prodRouteDetailMeal.mealType?contains("DINNER")&& !prodRouteDetailMeal.mealType?contains("SELF_DINNER"))>
	                     data-validate="{required:true,regular:true}"
	                    <#else>data-validate="{regular:true}" </#if>
	                    value="${routeDetailFormat.formatPrice(prodRouteDetailMeal.dinnerPrice)!''}" data-validate-regular="^\d*$" maxlength="5"/>
	                    <#else>
	                    <input type="text" class="form-control w85 JS_dinner_meal_price" 
	                    <#if productType!="FOREIGNLINE" && categoryId!=18 && (prodRouteDetailMeal.mealType?contains("DINNER")&& !prodRouteDetailMeal.mealType?contains("SELF_DINNER"))>
	                    data-validate="{required:true,regular:true}"
	                     <#else>data-validate="{regular:true}" </#if>
	                    value="${routeDetailFormat.formatPrice(prodRouteDetailMeal.price)!''}" data-validate-regular="^\d*$" maxlength="5"/>
	                    </#if>
	                        <select class="form-control w85 JS_select_switch_dinner" >
	                            <#list currencys as currency>
	                                <#if prodRouteDetailMeal.breakfastCurrency??>
			                        <option value="${currency.name()!''}"<#if currency.name()==prodRouteDetailMeal.dinnerCurrency>selected</#if>>${currency.cnName!''}</option>
			                        <#else>
			                        <option value="${currency.name()!''}"<#if currency.name()==prodRouteDetailMeal.currency>selected</#if>>${currency.cnName!''}</option>
			                        </#if>
			                    </#list>
	                        </select>
	                        /人/餐
	                    </div>
	                 </div>
	                 <div class="row">
	                 
	                 </div>
                 </div>
                 <#--开始时间  为“全天”  结束-->   
                    <div class="row JS_radio_switch_group">
                        <div class="col w70 module-label">
                            用餐地点：
                        </div>
                        <div class="col">
                            <span class="JS_radio_switch_box">
                                <label>
                                    <input type="radio" name="prodRouteDetailMealList[0].mealPlace" value=1 <#if prodRouteDetailMeal.mealPlace == "1">checked</#if> class="JS_radio_switch"/>
                                    酒店内
                                </label>
                            </span>
                            <span class="JS_radio_switch_box">
                                <input type="radio" name="prodRouteDetailMealList[0].mealPlace" value=2 <#if prodRouteDetailMeal.mealPlace=="2">checked</#if> class="JS_radio_switch"/>
                                <input type="text" class="form-control w250 JS_radio_disabled" <#if prodRouteDetailMeal.mealPlace!="2">disabled="disabled"</#if>
                                       placeholder="输入其他用餐地点" maxlength="50" name="prodRouteDetailMealList[0].mealPlaceOther" value="${prodRouteDetailMeal.mealPlaceOther}"/>
                            </span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col w90 module-label">
                            话术模板 <i class="icon icon-help" data-poptip="话术模板可以将你所填的内容整合成较为易懂的一段话"></i> ：
                        </div>
                        <div class="col">
                            <label>
                            	<input type="checkbox" class="JS_use_template_flag" name="prodRouteDetailMealList[0].useTemplateFlag" value="Y" <#if prodRouteDetailMeal.useTemplateFlag=="Y">checked</#if> />
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
                                    <textarea class="form-control textarea-content" name="prodRouteDetailMealList[0].mealDesc" value="${prodRouteDetailMeal.mealDesc!''}" maxlength="500" >${prodRouteDetailMeal.mealDesc!''}</textarea>
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
<#--用餐 END-->
