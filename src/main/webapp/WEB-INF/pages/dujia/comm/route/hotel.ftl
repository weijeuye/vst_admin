
<#assign hotel = prodRouteDetailHotelEmpty />
<#--酒店 START-->
<div class="module template-hotel <#if newStructureFlag == "Y">state-view<#else>state-edit</#if>" data-id="${routeDetailGroup.groupId}">
	<!--酒店模块头部 START-->
    <div class="module-head clearfix">
        <div class="module-title">住宿</div>
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
	<!--酒店模块头部 END-->
	
	<!--酒店查看 START-->
    <div class="view">
        <div class="module-post clearfix">
            <div class="module-post-left">
                <p><#if routeDetailGroup.startTime != "ALL_DAY">${routeDetailGroup.getTimeType()!''}</#if></p>
                <p class="text-gray module-local-time"><#if routeDetailGroup.localTimeFlag == "Y">当地时间</#if></p>
            </div>
            <div class="module-post-right">
            	<#if routeDetailGroup.prodRouteDetailHotelList?? && routeDetailGroup.prodRouteDetailHotelList?size &gt; 0>
            	<#--取第一个酒店对象-->
            	<#assign hotel = routeDetailGroup.prodRouteDetailHotelList[0] />
            		<#if hotel?? && hotel.useTemplateFlag == "Y">
	            		<div class="module-post-content">
	            			<#if routeDetailGroup.hotelTemplateText != "">
		            			<i class="icon-state icon-state-hotel"></i>
		            			<div class="view-content-new">${routeDetailGroup.hotelTemplateText?replace("\n", "<br/>")}</div>
			                </#if>
	            		</div>
	            	<#else>
	            		<#list routeDetailGroup.prodRouteDetailHotelList as item>
			                <div class="module-post-content">
			                    <i class="icon-state icon-state-hotel"></i>
			                    <#if item_index == 0>
				                    <div class="view-content-new">
				                    	<#-- 行驶的时间与距离 -->
					                    <#if item.travelTime != "" || item.distanceKM != "">
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
				                        	</div>
					                    </#if>
				                    </div>
			                   	</#if>
			                    <h3>
			                    	<#if item_index != 0 && item.logicRelateion != "">
				                    <span class="text-danger">（<#if item.logicRelateion == "AND">和<#elseif item.logicRelateion == "OR">或</#if>）</span>
				                    </#if>
				                    <#if item.hotelName != "未指定酒店">${item.hotelName!''}</#if>
			                        <small>${item.belongToPlace!''}</small>
			                    </h3>
			                    <div class="view-content-new">
			                    	<#if item.roomType != "">
				                    	<div class="row">
					                        <div class="col w65">房型：</div>
					                        <div class="col w700">${item.roomType!''}</div>
					                    </div>
			                    	</#if>
			                        <#if item.starLevelName != "">
				                    	<div class="row">
					                        <div class="col w65">星级：</div>
					                        <div class="col w700">${item.starLevelName!''}</div>
					                    </div>
			                    	</#if>
			                    	<#if item.hotelDesc != "">
			                    		<div class="row">${item.hotelDesc?replace("\n", "<br/>")}</div>
			                    	</#if>
			                    </div>
			                </div>
	            		</#list>
	            	</#if>
	            </#if>
            </div>
        </div>
    </div>
    
    <!--酒店查看 END-->

    <!--酒店编辑 START-->
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
            <#-- 排序值 -->
            <input type="hidden" name="sortValue" value="${routeDetailGroup.sortValue}"/>
            <#--模块类型-->
            <input type="hidden" name="moduleType" value="HOTEL"/>
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
                                <input type="text" class="form-control hourWidth JS_time_hour" value="<#if hasColon == "Y">${startTime[0]!''}<#else>${routeDetailGroup.getTimeType()!''}</#if>"
                                	placeholder="小时" data-validate="{required:true}" maxlength="2">
                                <span class="JS_time_blank"<#if hasColon == "N">style="display:none;"</#if> >:</span>
                                <input type="text" class="form-control w30 JS_time_minute" <#if hasColon == "N">disabled style="display:none;"</#if> value="<#if hasColon == "Y">${startTime[1]!''}</#if>"
                                	placeholder="分钟" data-validate="{required:true}" maxlength="2">
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
                <div class="hotel-list">
					<#if routeDetailGroup.prodRouteDetailHotelList?? && routeDetailGroup.prodRouteDetailHotelList?size &gt; 0>
					<#-- 各个酒店的行驶时间、行驶距离、是否使用模板都是一样的 -->
					<#assign hotel = routeDetailGroup.prodRouteDetailHotelList[0] />
            		<#list routeDetailGroup.prodRouteDetailHotelList as item>
            			<!--一个酒店 START-->
					    <div class="hotel-item state-added" data-index="${item_index}" data-id="${item.hotelId}">
					    	<#--单个酒店下的隐藏域DIV-->
                            <div class="JS_item_form_hidden" style="display:none">
                                 <#--主键ID-->
                                 <input type="hidden" class="hidden_hotel_id" name="prodRouteDetailHotelList[${item_index}].hotelId" value="${item.hotelId}"/>
                                 <#--产品ID-->
						         <input type="hidden" class="hidden_productId" name="prodRouteDetailHotelList[${item_index}].productId" value="${item.productId}"/>
						         <#--组ID-->
						         <input type="hidden" name="groupId" name="prodRouteDetailHotelList[${item_index}].groupId" value="${item.groupId}" />
						         <#--名称-->
						         <input type="hidden" class="hidden_hotel_name" name="prodRouteDetailHotelList[${item_index}].hotelName" value="<#if item.hotelName ?? && item.hotelName != "">${item.hotelName}<#else>未指定酒店</#if>" />
                                 <#--逻辑关系-->
                                 <input type="hidden" class="hidden_logic_relation" name="prodRouteDetailHotelList[${item_index}].logicRelateion" value="${item.logicRelateion}" />
                                 <#--出行类型-->
                                 <input type="hidden" class="hidden_travel_type" name="prodRouteDetailHotelList[${item_index}].travelType" value="${item.travelType}" />
                                 <#--出行时间-->
                                 <input type="hidden" class="hidden_travel_time" name="prodRouteDetailHotelList[${item_index}].travelTime" value="${item.travelTime}" />
                                 <#--行驶距离-->
                                 <input type="hidden" class="hidden_distanceKM" name="prodRouteDetailHotelList[${item_index}].distanceKM" value="${item.distanceKM}" />
                                 <#--是否使用模板-->
                                 <input type="hidden" class="hidden_useTemplateFlag" name="prodRouteDetailHotelList[${item_index}].useTemplateFlag" value="${item.useTemplateFlag}" />
                                 <#--模板CODE-->
                                 <input type="hidden" class="hidden_template_code" name="prodRouteDetailHotelList[${item_index}].templateCode" value="${item.templateCode}" />
                            </div>
                            
					        <!--酒店模块 添加前 START-->
					        <div class="hotel-initial">
					            <div class="row">
					                <div class="col w40 JS_hotel_and_or" name="prodRouteDetailHotelList[${item_index}].logicRelateion">
					                    <select class="form-control w40">
					                        <option value="OR" <#if item.logicRelateion=="OR">selected</#if> >或</option>
					                    </select>
					                </div>
					                <div class="col w80 module-label">
					                    入住酒店 <em class="text-danger">*</em> ：
					                </div>
					                <div class="col w410">
					                    <input type="text" class="form-control w390 JS_single_hotel_name" name="prodRouteDetailHotelList[${item_index}].hotelName" value="<#if item.hotelName ?? && item.hotelName != "">${item.hotelName}<#else>未指定酒店</#if>" placeholder="请输入酒店名称"
					                           maxlength="100" data-validate="{required:true,}" disabled/>
					                    <input type="hidden" class="JS_hotel_id"/>
					                </div>
					                <div class="col">
					                    <input class="btn btn-white JS_hotel_add" value="添加" type="button"
					                           data-validate="{regular:请点击添加或删除多余表单}" data-validate-regular="^[^.]$" disabled/>
					                </div>
					                <div class="col hotel-del-box">
					                    <a class="JS_hotel_del">删除</a>
					                </div>
					            </div>
					        </div>
					        <!--酒店模块 添加前 END-->
					
					        <!--酒店模块 添加后 START-->
					        <div class="hotel-form">
					            <div class="hotel-head">
					            	<#if item.logicRelateion?? && item_index != 0>
                                    	<span class="view-and-or hotel-and-or">
                                    	<select class="form-control w40">
					                        <option value="OR" <#if item.logicRelateion=="OR">selected</#if> >或</option>
					                    </select>
					                    </span>
                                    </#if>
					                <a class="JS_hotel_del">删除</a>
					            </div>
					            <div class="row">
					                <div class="col w70 module-label">
					                    入住酒店 ：
					                </div>
					                <div class="col w110 JS_hotel_name">
					                    <#if item.hotelName ?? && item.hotelName != "">${item.hotelName}<#else>未指定酒店</#if>
					                </div>
					                <div class="col w60 module-label">
					                   房型 ：
					                </div>
					                <div class="col w140 JS_div_hotel_roomType">
					                	<!-- 有酒店产品 -->
					                	<#if item.productId?? && item.productId != "">
											<!--房型  下拉菜单-->
            								<input type="hidden" name="prodRouteDetailHotelList[${item_index}].roomType" value="${item.roomType!''}" />
						                    <select class="form-control w110 JS_hotel_roomTypeId" name="prodRouteDetailHotelList[${item_index}].roomTypeId">
						                    	<option value="">不指定房型</option>
						                    	<#if item.roomTypeList?? && item.roomTypeList?size gt 0>
						                    		<#list item.roomTypeList as room>
							                    		<option value="${room.productBranchId!''}" <#if room.productBranchId==item.roomTypeId>selected</#if> >${room.branchName}</option>
							                        </#list>
						                    	</#if>
						                    </select>
										<#else>
											<!--房型 输入框-->
                							<input type="text" class="form-control w100" maxlength="100" name="prodRouteDetailHotelList[${item_index}].roomType" placeholder='输入房型' value="${item.roomType!''}">				                	
					                	</#if>
					                </div>
					                <div class="col w40 module-label">
					                    星级 ：
					                </div>
					                <div class="col w140">
					                	<input type="hidden" name="prodRouteDetailHotelList[${item_index}].starLevelName" value="${item.starLevelName!''}" />
					                    <select class="form-control input-hotel-star" name="prodRouteDetailHotelList[${item_index}].starLevel">
					                        <option value="-1">不显示星级</option>
						                    <!-- 有酒店产品 -->
						                	<#if item.productId?? && item.productId != "">
						                		<#list hotelStarList as hs>
	                                                <option value="${hs.dictId!''}" <#if hs.dictId==item.starLevel>selected</#if> >${hs.dictName!''}</option>
	                                            </#list>
						                    <#else>
							                    <#list prodStarList as ps>
	                                                <option value="${ps.dictId!''}" <#if ps.dictId==item.starLevel>selected</#if> >${ps.dictName!''}</option>
	                                            </#list>
						                    </#if>
					                    	
					                    </select>
					                </div>
					            </div>
					            <div class="row">
					                <div class="col module-label w70">
					                    所在地 ：
					                </div>
					                <div class="col">
					                	<#if item.productId??>
											${item.belongToPlace!''}
											<input type="hidden" name="prodRouteDetailHotelList[${item_index}].belongToPlace"  value="${item.belongToPlace!''}" />
					                    <#else>
					                    	<input type="text" class="form-control w190" name="prodRouteDetailHotelList[${item_index}].belongToPlace" value="${item.belongToPlace!''}" placeholder="请输入酒店所在地" maxlength="50"/>
					                    </#if>
					                </div>
					            </div>
					            <div class="row">
					                <div class="col module-label w70">
					                    酒店说明 ：
					                </div>
					                <div class="col">
					                    <div class="col JS_textares_box">
					                        <a class="textarea-content-expand JS_textarea_expand"
					                           data-text="展开酒店说明 <i class='triangle'></i>">
					                            添加酒店说明
					                            <i class="triangle"></i>
					                        </a>
					
					                        <div>
					                            <textarea class="form-control textarea-content" name="prodRouteDetailHotelList[${item_index}].hotelDesc" maxlength="500">${item.hotelDesc!''}</textarea>
					                        </div>
					
					                        <a class="textarea-content-shrink JS_textarea_shrink">
					                            收起酒店说明
					                            <i class="triangle"></i>
					                        </a>
					                    </div>
					                </div>
					            </div>
					        </div>
					        <!--酒店模块 添加后 END-->
					
					    </div>
					    <!--一个酒店 END-->
	            	</#list>
	            	</#if>
                </div>
                
                <#-- 底部增加酒店按钮 START -->
                <div class="hotel-increase">
                    <a class="btn btn-white JS_hotel_increase">
                        <i class="icon-add-item"></i>增加酒店
                    </a>
                </div>
				<#-- 底部增加酒店按钮 END -->
				
                <div class="row JS_travelType_travelTime_distanceKM">
                    <div class="col w110">
                        <select class="form-control w80 JS_activity_time" name="travelType">
                            <option value="DRIVE" <#if hotel?? && hotel.travelType=="DRIVE">selected</#if> >行驶时间</option>
                            <option value="WALK" <#if hotel?? && hotel.travelType=="WALK">selected</#if> >徒步时间</option>
                        </select>
                    </div>
                    <div class="col w160">
                    <#-- 出行时间 -->
                    <#if hotel?? && hotel.travelTime?? && hotel.travelTime != null>
                        <#assign travelTime = hotel.travelTime?split(":")/>
                    <#else>
                        <#assign travelTime = ['','']/>
                    </#if>
                    
                        <input type="text" class="form-control w30 JS_travel_hour" value="${travelTime[0]!''}"  data-validate="{regular:仅支持输入数字}"
                               data-validate-regular="^\d*$" maxlength="2"/>
                        小时
                        <input type="text" class="form-control w30 JS_travel_minute" value="${travelTime[1]!''}"  data-validate="{regular:仅支持输入数字}"
                               data-validate-regular="^\d*$" maxlength="2"/>
                        分钟；
                    </div>
		            <div class="col module-label w60 JS_activity_distance">
		            	<#if hotel?? && hotel.travelType=="WALK">徒步<#else>行驶</#if>距离
		            </div>
                    <div class="col w110">
                        约
                        <input type="text" class="form-control w30 JS_distanceKM" name="distanceKM" 
                        	value="${hotel.distanceKM!''}" data-validate="{regular:仅支持输入数字}" data-validate-regular="^\d*$" maxlength="4"/>
                        公里；
                    </div>
                </div>
                <div class="row">
                    <div class="col module-label w90">
                        话术模板 <i class="icon icon-help" data-poptip="话术模板可以将你所填的内容整合成较为易懂的一段话"></i> ：
                    </div>
                    <div class="col">
                        <label>
                            <input type="checkbox" class="JS_use_template_flag" name="useTemplateFlag" <#if hotel?? && hotel.useTemplateFlag=="Y">checked</#if>/>
                            使用系统提供的话术模板来显示信息
                        </label>
                        <a class="JS_hotel_preview">预览查看</a>
                    </div>
                </div>

            </div>
            <!--模块右侧 END-->
        </div>
	</form>
    </div>
    <!--酒店编辑 END-->

    <div class="day-module-add" <#if newStructureFlag=='N'>style="display:none"</#if>  >
        <div class="day-module-add-title">添加行程信息 <i class="triangle"></i></div>
    </div>

</div>
<#--酒店 END-->