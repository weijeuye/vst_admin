<#--定义是否为新结构标记变量-->
<#assign newStructureFlag = (prodLineRoute?? && prodLineRoute.newStructureFlag == "N")?string("N","Y") />

<#--购物 START-->
<div class="module template-shop <#if newStructureFlag == "Y">state-view<#else>state-edit</#if>" data-id="${routeDetailGroup.groupId}">

    <div class="module-head clearfix">
        <div class="module-title">购物点</div>

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

    <!--购物查看 START-->
    <div class="view">

        <div class="module-post clearfix">

            <div class="module-post-left">
                <p><#if routeDetailGroup.startTime != "ALL_DAY">${routeDetailGroup.getTimeType()!''}</#if></p>
                <#if routeDetailGroup.localTimeFlag == "Y"><p class="text-gray module-local-time">当地时间</p></#if>
            </div>
			<div class="module-post-right">
	            <#if routeDetailGroup.prodRouteDetailShoppingList?? && routeDetailGroup.prodRouteDetailShoppingList?size &gt; 0>
		            <#list routeDetailGroup.prodRouteDetailShoppingList as item>
			              <div class="module-post-content">
			              	<i class="icon-state icon-state-shopping"></i>
						     <#if item.useTemplateFlag == "Y">
					                <#-- 话术模板展示 开始 -->
					                <div class="view-content-new">
					                    <div class="row">
					                        <#if item_index != 0 && item.logicRelation != "">
					                        	<span class="text-danger">（<#if item.logicRelation == "AND">和<#elseif item.logicRelation == "OR">或</#if>）</span>
					                        </#if>
					                        <#if item.templateText??>
					                        	${item.templateText?replace('【', '<span class="font-big">')?replace('】', '</span>')?replace('\n', '<br/>')}
					                        </#if>
					                    </div>
					                </div>
					                <#-- 话术模板展示 结束 -->
						     <#else>
				                    <#-- 非话术模板展示 开始 -->
				                    <h3>
					                    <#if item_index != 0 && item.logicRelation != "">
					                    <span class="text-danger">（<#if item.logicRelation == "AND">和<#elseif item.logicRelation == "OR">或</#if>）</span>
					                    </#if>
					                    ${item.shoppingName!''}
					                    <#if item.recommendFlag == "Y">
							                  <small>推荐购物点</small>
										</#if>
					                </h3>
					                <div class="view-content-new">
					                	<#-- 行驶的时间与距离 -->
					                    <#if item.travelTime != "" || item.distanceKM != "" || item.visitTime != "">
						                    <div class="row">
						                        <!-- 出行时间 -->
						                        <#assign travelTypeStr = routeDetailFormat.getTravelTypeCnName(item.travelType)/>
						                        <#assign travelTimeStr = routeDetailFormat.getTimeStr(item.travelTime)/>
						                        <#if travelTypeStr != "" && travelTimeStr != "">
							                        <div class="col w65">
							                            ${travelTypeStr!''}时间：
							                        </div>
							                        <div class="col row-inline-mr25">
							                            ${travelTimeStr!''}
							                        </div>
						                        </#if>
						
						                        <!-- 行程距离 -->
						                        <#if travelTypeStr != "" && item.distanceKM != "">
							                        <div class="col w65">
							                            ${travelTypeStr!''}距离：
							                        </div>
							                        <div class="col row-inline-mr25">
							                            	约${item.distanceKM!''}公里
							                        </div>
						                        </#if>
						
						                        <!-- 游览时间 -->
						                        <#assign visitTimeStr = routeDetailFormat.getTimeStr(item.visitTime)/>
						                        <#if visitTimeStr != "">
							                        <div class="col w65">
							                          		  游览时间：
							                        </div>
							                        <div class="col row-inline-mr25">
							                            ${visitTimeStr!''}
							                        </div>
						                        </#if>
						                  	</div>
					                  	</#if>
					                  	<#if item.address != "">
						                  	 <div class="row">
				                                <div class="col w65">
				                                   	 地址：
				                                </div>
				                                <div class="col w700">
				                                	${item.address!''}
				                                </div>
				                             </div>
				                     	</#if>
				                     	<#if item.mainProducts != "">
					                       	<div class="row">
				                                <div class="col w65">
				                                  	  主营产品：
				                                </div>
				                                <div class="col w700">
				                                  	 ${item.mainProducts!''}
				                                </div>
				                            </div>
					                     </#if>
				                     	<#if item.subjoinProducts != "">
					                        <div class="row">
				                                <div class="col w65">
				                                    	兼营产品：
				                                </div>
				                                <div class="col w700">
				                                     ${item.subjoinProducts!''}
				                                </div>
				                            </div>
				                         </#if>
				                         <#if item.shoppingDesc != "">
				                        	<div class="row">
				                        		${item.shoppingDesc?replace('\n', '<br/>')}
				                        	</div>
				                        </#if> 
					                </div>
				                    <#-- 非话术模板展示 结束 -->
				     		 </#if>
				     	  </div>
		            </#list>
	            </#if>
            </div>
        </div>
    </div>
    <!--购物查看 END-->

    <!--购物编辑 START-->
    <div class="edit">
    <form>
        <#-- 组隐藏域DIV -->
        <div class="JS_group_form_hidden" style="display:none">
            <#--行程ID-->
            <input type="hidden" name="routeId" value="${routeDetailGroup.routeId}" />
            <#--行程明细ID-->
            <input type="hidden" name="detailId" value="${routeDetailGroup.detailId}" />
            <#--组ID-->
            <input type="hidden" name="groupId" value="${routeDetailGroup.groupId}" />
            <#--开始时间-->
            <input type="hidden" name="startTime" value="${routeDetailGroup.startTime}" />
            <#--排序顺序-->
            <input type="hidden" name="sortValue" value="${routeDetailGroup.sortValue}"/>
            <#--模块类型-->
            <input type="hidden" name="moduleType" value="SHOPPING"/>
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
                                <input type="text" class="form-control hourWidth JS_time_hour" placeholder="小时"
                                       data-validate="{required:true}" maxlength="2" value="<#if hasColon == "Y">${startTime[0]!''}<#else>${routeDetailGroup.getTimeType()!''}</#if>">
                                <span class="JS_time_blank" <#if hasColon == "N">style="display:none;"</#if> >:</span>
                                <input type="text" class="form-control w30 JS_time_minute" placeholder="分钟"
                                       data-validate="{required:true}" maxlength="2" <#if hasColon == "N">disabled style="display:none;"</#if> value="<#if hasColon == "Y">${startTime[1]!''}</#if>">
                            </span>
                        </p>

                        <p>
                            <label class="inline-block">
                                <input type="checkbox" name="localTimeFlag" value="Y" <#if routeDetailGroup.localTimeFlag=="Y">checked="checked"</#if> >
                                当地时间
                            </label>
                        </p>
                    </div>
                </div>
            </div>
            <!--模块左侧 END-->

            <!--模块右侧 START-->
            <div class="module-main">

                <div class="shop-list">
 					<#-- 购物子项循环START-->
                    <#if routeDetailGroup.prodRouteDetailShoppingList?? && routeDetailGroup.prodRouteDetailShoppingList?size &gt; 0>
	                    <#list routeDetailGroup.prodRouteDetailShoppingList as item>
	                        <div class="shop-item state-added view-shop-item" data-index="${item_index}" data-id="${item.shoppingId}">
	
	                            <#--单个景点下的隐藏域DIV-->
	                            <div class="JS_item_form_hidden" style="display:none">
						         <#--主键ID-->
						         <input type="hidden" class="hidden_shopping_id" name="prodRouteDetailShoppingList[${item_index}].shoppingId" value="${item.shoppingId}"/>
						         <#--名称ID-->
						         <input type="hidden" class="hidden_shopping_name_id" name="prodRouteDetailShoppingList[${item_index}].destId" value="${item.destId}"/>
						         <#--名称-->
						         <input type="hidden" class="hidden_shopping_name" name="prodRouteDetailShoppingList[${item_index}].shoppingName" value="${item.shoppingName}" />
						         <#--逻辑关系-->
						         <#--<input type="hidden" class="hidden_logic_relation" name="prodRouteDetailShoppingList[${item_index}].logicRelation" value="${item.logicRelation}" />-->
						         <#--出行时间-->
						         <input type="hidden" class="hidden_travel_time" name="prodRouteDetailShoppingList[${item_index}].travelTime" value="${item.travelTime}" />
						         <#--参观时间-->
						         <input type="hidden" class="hidden_visit_time" name="prodRouteDetailShoppingList[${item_index}].visitTime" value="${item.visitTime}" />
						         <#--模板CODE-->
						         <input type="hidden" class="hidden_template_code" name="prodRouteDetailShoppingList[${item_index}].templateCode" value="${item.templateCode}" />
						    	</div>
			
							    <!--购物模块 添加前 START-->
							    <div class="shop-initial">
							        <div class="row">
							            <div class="col w40 JS_shop_and_or">
							                <select class="form-control w40">
							                    <option value="OR" <#if item.logicRelation=="OR">selected</#if> >或</option>
							                    <option value="AND" <#if item.logicRelation=="AND">selected</#if> >和</option>
							                </select>
							            </div>
							            <div class="col w70 module-label">
							                购物点 <em class="text-danger">*</em> ：
							            </div>
							            <div class="col w410">
							                <input type="text" class="form-control w390 JS_shop_name" placeholder="请输入购物点名称"
							                       maxlength="100" data-validate="{required:true,}" value="${item.shoppingName!''}" disabled/>
							            </div>
							            <div class="col">
							                <input class="btn btn-white JS_shop_add" value="添加" type="button"
							                       data-validate="{regular:请点击添加或删除多余表单}" data-validate-regular="^[^.]$" disabled/>
							            </div>
							            <div class="col shop-del-box">
							                <a class="JS_shop_del">删除</a>
							            </div>
							        </div>
							    </div>
							    <!--购物模块 添加前 END-->
							
							    <!--购物模块 添加后 START-->
							    <div class="shop-form">
							        <div class="shop-head">
								        <#if item_index != 0>
		                                    <div class="col w40 JS_shop_and_or">
		                                        <select class="form-control w40" name="prodRouteDetailShoppingList[${item_index}].logicRelation" >
		                                            <option value="OR" <#if item.logicRelation=="OR">selected</#if> >或</option>
		                                            <option value="AND" <#if item.logicRelation=="AND">selected</#if> >和</option>
		                                        </select>
		                                    </div>
	                                    </#if>
							            <a class="JS_shop_del">删除</a>
							        </div>
							        <div class="row">
							            <div class="col w70 module-label">
							                购物点 ：
							            </div>
							            <div class="col w380 JS_shop_name">
							                ${item.shoppingName!''}
							            </div>
							            <div class="col">
							                <label>
							                    <input type="checkbox" name="prodRouteDetailShoppingList[${item_index}].recommendFlag" value="Y" <#if item.recommendFlag=="Y">checked</#if>/>
							                    推荐购物点
							                </label>
							            </div>
							        </div>
							        <div class="row">
							            <div class="col module-label w70">
							                <em>*</em>地址 ：
							            </div>
							            <div class="col">
							                <input type="text" class="form-control w310" data-validate="{required:true}"  maxlength="100" name="prodRouteDetailShoppingList[${item_index}].address" value="${item.address!''}"/>
							            </div>
							
							        </div>
							        <div class="row">
							            <div class="col module-label w70">
							                <em>*</em>主营产品 ：
							            </div>
							            <div class="col w220">
							                <input type="text" class="form-control w180" data-validate="{required:true}" maxlength="100" name="prodRouteDetailShoppingList[${item_index}].mainProducts" value="${item.mainProducts!''}"/>
							            </div>
							            <div class="col module-label w70">
							                兼营产品 ：
							            </div>
							            <div class="col">
							                <input type="text" class="form-control w180" maxlength="100" name="prodRouteDetailShoppingList[${item_index}].subjoinProducts" value="${item.subjoinProducts!''}"/>
							            </div>
							
							        </div>
							        <div class="row">
							            <div class="col w110">
							                <select class="form-control w80 JS_activity_time" name="prodRouteDetailShoppingList[${item_index}].travelType">
							                    <option value="DRIVE" <#if item.travelType=="DRIVE">selected</#if> >行驶时间</option>
							                    <option value="WALK" <#if item.travelType=="WALK">selected</#if> >徒步时间</option>
							                </select>
							            </div>
							            <#-- 出行时间 -->
							            <#if item.travelTime?? && item.travelTime != null>
							                <#assign travelTime = item.travelTime?split(":")/>
							            <#else>
							                <#assign travelTime = ['','']/>
							            </#if>
							            <div class="col w160">
							                <input type="text" class="form-control w30 JS_travel_hour" data-validate="{regular:仅支持输入数字}"
							                       data-validate-regular="^\d*$" maxlength="2" value="${travelTime[0]!''}"/>
							                小时
							                <input type="text" class="form-control w30 JS_travel_minute" data-validate="{regular:仅支持输入数字}"
							                       data-validate-regular="^\d*$" maxlength="2" value="${travelTime[1]!''}"/>
							                分钟；
							            </div>
							            <#if item.travelType=="WALK">
								            <div class="col module-label w60 JS_activity_distance">
								                	 徒步距离
								            </div>
								         <#else>
								         	<div class="col module-label w60 JS_activity_distance">
								                	行驶距离
								            </div>
							            </#if>
							            
							            <div class="col w110">
							                约
							                <input type="text" class="form-control w30" data-validate="{regular:仅支持输入数字}"
							                       data-validate-regular="^\d*$" maxlength="4"  name="prodRouteDetailShoppingList[${item_index}].distanceKM" value="${item.distanceKM}" />
							                公里；
							            </div>
							 	    <#-- 参观时间 -->
							            <#if item.visitTime?? && item.visitTime != null>
							                <#assign visitTime = item.visitTime?split(":")/>
							            <#else>
							                <#assign visitTime = ['','']/>
							            </#if>
							            <div class="col module-label w70"><em>*</em>
							                参观时间：
							            </div>
							            <div class="col">
							                <input type="text" class="form-control w30 JS_visit_hour" data-validate="{regular:仅支持输入数字,required:true}"
							                       data-validate-regular="^\d*$" maxlength="2" value="${visitTime[0]!''}"/>
							                小时
							                <input type="text" class="form-control w30 JS_visit_minute" data-validate="{regular:仅支持输入数字,required:true}"
							                       data-validate-regular="^\d*$" maxlength="2" value="${visitTime[1]!''}"/>
							                分钟；
							            </div>
							        </div>
							        <div class="row">
							            <div class="col module-label w90">
							                话术模板 <i class="icon icon-help" data-poptip="话术模板可以将你所填的内容整合成较为易懂的一段话"></i> ：
							            </div>
							            <div class="col">
							                <label>
							                    <input type="checkbox" class="JS_use_template_flag" name="prodRouteDetailShoppingList[${item_index}].useTemplateFlag" value="Y" <#if item.useTemplateFlag=="Y">checked</#if> />
							                    使用系统提供的话术模板来显示信息
							                </label>
							                <a class="JS_shop_preview">预览查看</a>
							            </div>
							        </div>
							        <div class="row">
							            <div class="col module-label w80">
							                购物点说明 ：
							            </div>
							            <div class="col">
							                <div class="col JS_textares_box">
							                    <a class="textarea-content-expand JS_textarea_expand"
							                       data-text="展开购物点说明 <i class='triangle'></i>">
							                        添加购物点说明
							                        <i class="triangle"></i>
							                    </a>
							
							                    <div>
							                        <textarea class="form-control textarea-content" name="prodRouteDetailShoppingList[${item_index}].shoppingDesc" maxlength="500">${item.shoppingDesc!''}</textarea>
							                    </div>
							
							                    <a class="textarea-content-shrink JS_textarea_shrink">
							                        收起购物点说明
							                        <i class="triangle"></i>
							                    </a>
							                </div>
							            </div>
							        </div>
							    </div>
							    <!--购物模块 添加后 END-->
							
			                </div>
			           	   
			            </#list>
                	</#if>
                	<#-- 购物子项循环END-->
				 </div>
                <div class="shop-increase">
                    <a class="btn btn-white JS_shop_increase">
                    	<span class="icon-add-item"></span>
                    	增加购物点
                    </a>
                </div>
            </div>
            <!--模块右侧 END-->
        </div>
    </form>
    </div>
    <!--购物编辑 END-->

    <div class="day-module-add">
        <div class="day-module-add-title">添加行程信息 <i class="triangle"></i></div>
    </div>

</div>
<#--购物 END-->