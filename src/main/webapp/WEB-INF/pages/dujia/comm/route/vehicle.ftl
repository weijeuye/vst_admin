<#--定义交通对象-->
<#if routeDetailGroup.prodRouteDetailVehicleList?? && routeDetailGroup.prodRouteDetailVehicleList?size &gt; 0>
    <#assign routeDetailVehicle = routeDetailGroup.prodRouteDetailVehicleList[0] />
<#else>
    <#assign routeDetailVehicle = prodRouteDetailVehicleEmpty />
</#if>

<#--交通类型-->
<#assign vehicleType=routeDetailVehicle.vehicleType/>

<#--交通时间-->
<#if routeDetailVehicle.vehicleTime?? && routeDetailVehicle.vehicleTime != null>
    <#assign vehicleTime = routeDetailVehicle.vehicleTime?split(":")/>
<#else>
    <#assign vehicleTime = ['','']/>
</#if>

<#--交通类型-->
<#if vehicleType=='PLANE'>
	<#assign vehicleTypeName = '飞机'>
<#elseif vehicleType=='TRAIN'>
	<#assign vehicleTypeName = '火车'>
<#elseif vehicleType=='BARS'>
	<#assign vehicleTypeName = '巴士'>
<#elseif vehicleType=='BOAT'>
	<#assign vehicleTypeName = '轮船'>
<#elseif vehicleType=='CRUISE'>
	<#assign vehicleTypeName = '邮轮'>
<#elseif vehicleType=='OTHERS'>
	<#assign vehicleTypeName = "其他-${routeDetailVehicle.vehicleOtherInfo!''}">
</#if>

<#--定义是否为新结构标记变量-->
<#assign newStructureFlag = (prodLineRoute?? && prodLineRoute.newStructureFlag == "N")?string("N","Y") />

<div class="module template-traffic <#if newStructureFlag == "Y">state-view<#else>state-edit</#if>" data-id="${routeDetailGroup.groupId}">

        <div class="module-head clearfix">
            <div class="module-title">交通</div>

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

        <!--交通查看 START-->
        <div class="view">
            <div class="module-post clearfix">
                <div class="module-post-left">
                    <p>${routeDetailGroup.getTimeType()!''}</p>
                    <#if routeDetailGroup.localTimeFlag =="Y"><p class="text-gray module-local-time">当地时间</p></#if>
                </div>
                <div class="module-post-right">
                    <div class="module-post-content">
                    	<#if vehicleType=='PLANE'>
		                    <i class="icon-state icon-state-traffic-air"></i>
		                <#elseif vehicleType=='TRAIN'>
						    <i class="icon-state icon-state-traffic-train"></i>
						<#elseif vehicleType=='BARS'>
						    <i class="icon-state icon-state-traffic-bus"></i>
						<#elseif vehicleType=='BOAT'>
						    <i class="icon-state icon-state-traffic-steamer"></i>
						 <#elseif vehicleType=='CRUISE'>
						    <i class="icon-state icon-state-traffic-mail"></i>
						  <#elseif vehicleType=='OTHERS'>
						    <i class="icon-state icon-state-traffic-other"></i>
						  </#if>
                    <h3>
						${vehicleTypeName}
                    </h3>
						<div class="view-content-new">
                            <div class="row">
						<#if vehicleType !='OTHERS'>
							<#--没有飞行时间-->
							<#if vehicleTime[0] !='' || vehicleTime[1] !=''>
								<div class="col w65">
									 <#if vehicleType=='PLANE'>飞行<#else>行驶</#if>时间：
								</div>
								<div class="col row-inline-mr25">
									 约<#if vehicleTime[0]?? &&vehicleTime[0] !=''> ${vehicleTime[0]!''}小时</#if>
									 <#if vehicleTime[1]?? &&vehicleTime[1] !=''> ${vehicleTime[1]!''}分钟</#if>
									 <#if routeDetailVehicle.vehicleKm !=''> &nbsp;&nbsp;行驶距离：约${routeDetailVehicle.vehicleKm!''}公里</#if>
								</div>
							<#elseif routeDetailVehicle.vehicleKm !=''>
								 <div class="col w65">
									 行驶距离：
								</div>
								<div class="col row-inline-mr25">
									 约${routeDetailVehicle.vehicleKm!''}公里
								</div>
							</#if>
                        </#if>
							</div>
							<div class="row">
            <#if vehicleType=='PLANE' && routeDetailVehicle.pickUpFlag == 'Y'>
								<div class="col w65">
	                          	  接机服务：
								</div>
								<div class="col w700">
	                           	 接机人员第${routeDetailVehicle.pickUpDay}天接机；
								</div>
	        <#elseif vehicleType=='TRAIN' && routeDetailVehicle.pickUpFlag == 'Y'>
								<div class="col w65">
	                            接车服务：
								</div>
								<div class="col w700">
	                            接车人员第${routeDetailVehicle.pickUpDay}天接车；
								</div>
            </#if>
							</div>
							<#if routeDetailVehicle.vehicleDesc != "">
							<div class="row">
                                ${routeDetailVehicle.vehicleDesc?replace("\n", "<br/>")}
							</div>
							</#if>
						</div>
					</div>
				</div>
            </div>
        </div>
        <!--交通查看 END-->

        <!--交通编辑 START-->
        <div class="edit">
        	 <form>
			<#-- 隐藏域用来放隐藏Input -->
	        <div class="JS_group_form_hidden">
	            <input type="hidden" name="routeId" value="${routeDetailGroup.routeId}" />
	            <input type="hidden" name="detailId" value="${routeDetailGroup.detailId}" />
	            <input type="hidden" name="groupId" value="${routeDetailGroup.groupId}" />
	            <input type="hidden" name="startTime" value="${routeDetailGroup.startTime}" />
	            <input type="hidden" name="moduleType" value="VEHICLE"/>
	            <input type="hidden" name="sortValue" value="${routeDetailGroup.sortValue}"/>
	        </div>
            <div class="clearfix">
                <!--模块左侧 START-->
                <div class="module-side">
	                <#-- 组的开始时间-->
	                <#if routeDetailGroup.startTime?? && routeDetailGroup.startTime?contains(":")>
	                    <#assign hasColon = "Y"/>
	                    <#assign groupStartTime = routeDetailGroup.startTime?split(":")/>
	                <#else>
	                    <#assign hasColon = "N"/>
	                </#if>
                    <div class="row">
                        <div class="col module-label w70"><em>*</em>开始时间：</div>
                        <div class="col">
                            <p>
                                <span class="JS_time_input">
                                <span class="JS_time_about w20 inline-block">约</span>
                                    <input type="text" class="form-control hourWidth JS_time_hour" placeholder="小时" data-validate="{required:true}" maxlength="2"
                                    	value="<#if hasColon == "Y">${groupStartTime[0]!''}<#else>${routeDetailGroup.getTimeType()!''}</#if>"
                                    >
                                    <span class="JS_time_blank" <#if hasColon == "N">style="display:none;"</#if> >:</span>
                                    <input type="text" class="form-control w30 JS_time_minute" placeholder="分钟" data-validate="{required:true}" maxlength="2"
                                    	<#if hasColon == "N">disabled style="display:none;"</#if> value="<#if hasColon == "Y">${groupStartTime[1]!''}</#if>"
                                    >
                                </span>
                            </p>

                            <p>
                                <label class="inline-block">
                                    <input type="checkbox"  name="localTimeFlag" value="Y" <#if routeDetailGroup.localTimeFlag =="Y">checked="checked"</#if>>
                                    当地时间
                                </label>
                            </p>
                        </div>
                    </div>
                </div>
                <!--模块左侧 END-->

                <!--模块右侧 START-->
                <div class="module-main traffic-module-main">
                	<div class="JS_item_form_hidden" style="display:none">
               			<input type="hidden" class="hidden_vehicle_time" name="prodRouteDetailVehicleList[0].vehicleTime" 
               				value="${routeDetailVehicle.vehicleTime!''}" />
               			<input type="hidden" name="prodRouteDetailVehicleList[0].groupId" value="${routeDetailVehicle.groupId}"/>
               			<input type="hidden" name="prodRouteDetailVehicleList[0].vehicleId" value="${routeDetailVehicle.vehicleId}"/>
                	</div>
                    <div class="row">
                        <div class="col module-label w70"><em>*</em>交通类型：</div>
                        <div class="col form-group">
                            <label class="mr10">
                                <input data-validate="{required:true}" class="traffic-tab" type="radio"
                                	name="prodRouteDetailVehicleList[0].vehicleType" value="PLANE" <#if vehicleType=='PLANE'>checked</#if> >
                                飞机
                            </label>
                            <label class="mr10">
                                <input data-validate="{required:true}" class="traffic-tab" type="radio"
                                	name="prodRouteDetailVehicleList[0].vehicleType" value="TRAIN" <#if vehicleType=='TRAIN'>checked</#if> >
                                火车
                            </label>
                            <label class="mr10">
                                <input data-validate="{required:true}" class="traffic-tab" type="radio"
                                	name="prodRouteDetailVehicleList[0].vehicleType" value="BARS" <#if vehicleType=='BARS'>checked</#if> >
                                巴士
                            </label>
                            <label class="mr10">
                                <input data-validate="{required:true}" class="traffic-tab" type="radio"
                                	name="prodRouteDetailVehicleList[0].vehicleType" value="BOAT" <#if vehicleType=='BOAT'>checked</#if> >
                                轮船
                            </label>
                            <label class="mr10">
                                <input data-validate="{required:true}" class="traffic-tab" type="radio"
                                	name="prodRouteDetailVehicleList[0].vehicleType" value="CRUISE"  <#if vehicleType=='CRUISE'>checked</#if> >
                                邮轮
                            </label>
                            <label class="mr10">
                                <input data-validate="{required:true}" class="traffic-tab" type="radio"
                                	name="prodRouteDetailVehicleList[0].vehicleType" value="OTHERS" <#if vehicleType=='OTHERS'>checked</#if> >
                                其他
                            </label>
                            <input type="text" class="form-control w200 JS_traffic_other_details" <#if vehicleType !='OTHERS'>disabled="disabled" </#if>
                            	name="prodRouteDetailVehicleList[0].vehicleOtherInfo"
                            	maxlength="50"
                            	data-validate="{required:true}"
                            	<#if vehicleType=='OTHERS' && routeDetailVehicle.vehicleOtherInfo?? >value='${routeDetailVehicle.vehicleOtherInfo!''}'</#if> >
                        </div>
                    </div>

                    <!--飞机 START-->
                    <div class="traffic-item <#if vehicleType=='PLANE'>active</#if>">
                        <div class="row">
                            <div class="col w70 module-label"><#if flightTimeValidate == 'Y'><em>*</em><#else></#if>
                                飞行时间：
                            </div>
                            <div class="col w170">
                                <input type="text" class="form-control w30  JS_vehicle_hour JS_vehicle_hour_blur" <#if flightTimeValidate == 'Y'>data-validate="{required:true,regular:true}"<#else>data-validate="{regular:true}"</#if> data-validate-regular="^\d*$" maxlength="2" 
                                	<#if vehicleType!='PLANE'>disabled</#if> <#if vehicleType=='PLANE'> value="${vehicleTime[0]!''}"</#if>  >
                                小时
                                <input type="text" class="form-control w30  JS_vehicle_minute JS_vehicle_minute_blur" <#if flightTimeValidate == 'Y'>data-validate="{required:true,regular:true}"<#else>data-validate="{regular:true}"</#if> data-validate-regular="^\d*$" maxlength="2"
									<#if vehicleType!='PLANE'>disabled</#if> <#if vehicleType=='PLANE'>value="${vehicleTime[1]!''}"</#if> >
                                分钟；
                            </div>
                            <div class="col w70 module-label">
                                行驶距离：
                            </div>
                            <div class="col clearfix">
                                <input type="text" class="form-control w50" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="6"
                                	<#if vehicleType!='PLANE'>disabled</#if>
                                	name="prodRouteDetailVehicleList[0].vehicleKm"  <#if vehicleType=='PLANE'>value = '${routeDetailVehicle.vehicleKm!''}'</#if> >
                                公里
                            </div>
                        </div>
                        <div class="row">
                            <div class="col w70 module-label">
                                接机服务 ：
                            </div>
                            <div class="col traffic-label">
                                <label><input class="form-control traffic-form-control-input"
                                		 name="prodRouteDetailVehicleList[0].pickUpFlag" value='Y' 
                                		 <#if vehicleType=='PLANE' && routeDetailVehicle.pickUpFlag=='Y'>checked</#if>
                                		 <#if vehicleType!='PLANE'>disabled</#if>
                                		 type="checkbox">接机人员第</label>
                                <select class="form-control traffic-form-control" name="prodRouteDetailVehicleList[0].pickUpDay"
                                	<#if vehicleType!='PLANE'>disabled</#if> >
                                	<#list day_index..real_route_Num as local_day_index>
	                                    <option value='${local_day_index}' 
	                                    	<#if vehicleType=='PLANE'
	                                    		&& routeDetailVehicle.pickUpFlag=='Y' 
	                                    		&& local_day_index == routeDetailVehicle.pickUpDay>selected</#if>  >
	                                    	${local_day_index}
	                                    </option>
                                    </#list>
                                </select>
                                天接机
                            </div>
                        </div>
                        <div class="row">
                            <div class="col w70 module-label">
                                交通说明 ：
                            </div>
                            <div class="col">
                                <div class="col JS_textares_box">
                                    <a class="textarea-content-expand JS_textarea_expand" data-text="展开交通说明 <i class='triangle'></i>">
                                        添加交通说明
                                        <i class="triangle"></i>
                                    </a>

                                    <div>
                                        <textarea class="form-control textarea-content" maxlength="500"
                                        	<#if vehicleType!='PLANE'>disabled</#if>
                                        	name='prodRouteDetailVehicleList[0].vehicleDesc'><#if vehicleType=='PLANE'>${routeDetailVehicle.vehicleDesc!''}</#if></textarea>
                                    </div>

                                    <a class="textarea-content-shrink JS_textarea_shrink">
                                        收起交通说明
                                        <i class="triangle"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--飞机 END-->

                    <!--火车 START-->
                    <div class="traffic-item <#if vehicleType=='TRAIN'>active</#if>">
                        <div class="row">
                            <div class="col w70 module-label">
                                行驶时间：
                            </div>
                            <div class="col w170">
                                <input type="text" class="form-control w30  JS_vehicle_hour" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2"
                                	<#if vehicleType!='TRAIN'>disabled</#if> <#if vehicleType=='TRAIN'>value="${vehicleTime[0]!''}"</#if> >
                                小时
                                <input type="text" class="form-control w30  JS_vehicle_minute" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2"
                                	<#if vehicleType!='TRAIN'>disabled</#if>  <#if vehicleType=='TRAIN'>value="${vehicleTime[1]!''}"</#if> >
                                分钟；
                            </div>
                            <div class="col w70 module-label">
                                行驶距离：
                            </div>
                            <div class="col clearfix">
                                <input type="text" class="form-control w50" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="6"
                                	<#if vehicleType!='TRAIN'>disabled</#if>
                                	name="prodRouteDetailVehicleList[0].vehicleKm" <#if vehicleType=='TRAIN'>value = '${routeDetailVehicle.vehicleKm!''}'</#if> >
                                公里
                            </div>
                        </div>

                        <div class="row">
                            <div class="col w70 module-label">
                                接车服务 ：
                            </div>
                            <div class="col traffic-label">
  								<label><input class="form-control traffic-form-control-input"
                                		 name="prodRouteDetailVehicleList[0].pickUpFlag" value="Y" 
                                		 <#if vehicleType!='TRAIN'>disabled</#if>
                                		 <#if vehicleType=='TRAIN' && routeDetailVehicle.pickUpFlag=='Y'>checked</#if>
                                		 type="checkbox">接车人员第</label>
                                <select class="form-control traffic-form-control"  name="prodRouteDetailVehicleList[0].pickUpDay"
                                	<#if vehicleType!='TRAIN'>disabled</#if> >
                                	<#list day_index..real_route_Num as local_day_index>
	                                    <option value='${local_day_index}' 
	                                    	<#if vehicleType=='TRAIN' && routeDetailVehicle.pickUpFlag=='Y' && local_day_index == routeDetailVehicle.pickUpDay>selected</#if>  >
	                                    	${local_day_index}
	                                    </option>
                                    </#list>
                                </select>
                                天接车
                            </div>
                        </div>
                        <div class="row">
                            <div class="col w70 module-label">
                                交通说明 ：
                            </div>
                            <div class="col">
                                <div class="col JS_textares_box">
                                    <a class="textarea-content-expand JS_textarea_expand" data-text="展开交通说明 <i class='triangle'></i>">
                                        添加交通说明
                                        <i class="triangle"></i>
                                    </a>

                                    <div>
                                        <textarea class="form-control textarea-content" maxlength="500" name="prodRouteDetailVehicleList[0].vehicleDesc"
                                        	<#if vehicleType!='TRAIN'>disabled</#if> ><#if vehicleType=='TRAIN'>${routeDetailVehicle.vehicleDesc!''}</#if></textarea>
                                    </div>

                                    <a class="textarea-content-shrink JS_textarea_shrink">
                                        收起交通说明
                                        <i class="triangle"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--火车 END-->

                    <!--巴士 START-->
                    <div class="traffic-item <#if vehicleType=='BARS'>active</#if>">
                        <div class="row">
                            <div class="col w70 module-label">
                                行驶时间：
                            </div>
                            <div class="col w170">
                                <input type="text" class="form-control w30  JS_vehicle_hour" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2"
                                	<#if vehicleType!='BARS'>disabled</#if> <#if vehicleType=='BARS'>value="${vehicleTime[0]!''}"</#if> >
                                小时
                                <input type="text" class="form-control w30  JS_vehicle_minute" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2"
                                	<#if vehicleType!='BARS'>disabled</#if> <#if vehicleType=='BARS'>value="${vehicleTime[1]!''}"</#if> >
                                分钟；
                            </div>
                            <div class="col w70 module-label">
                                行驶距离：
                            </div>
                            <div class="col clearfix">
                                <input type="text" class="form-control w50" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="6"
                               		<#if vehicleType!='BARS'>disabled</#if>
                                	name="prodRouteDetailVehicleList[0].vehicleKm" <#if vehicleType=='BARS'>value = '${routeDetailVehicle.vehicleKm!''}'</#if> >
                                公里
                            </div>
                        </div>

                        <div class="row">
                            <div class="col w70 module-label">
                                交通说明 ：
                            </div>
                            <div class="col">
                                <div class="col JS_textares_box">
                                    <a class="textarea-content-expand JS_textarea_expand" data-text="展开交通说明 <i class='triangle'></i>">
                                        添加交通说明
                                        <i class="triangle"></i>
                                    </a>

                                    <div>
                                        <textarea class="form-control textarea-content" maxlength="500" name='prodRouteDetailVehicleList[0].vehicleDesc'
                                        	<#if vehicleType!='BARS'>disabled</#if>
                                        	><#if vehicleType=='BARS'>${routeDetailVehicle.vehicleDesc!''}</#if></textarea>
                                    </div>

                                    <a class="textarea-content-shrink JS_textarea_shrink">
                                        收起交通说明
                                        <i class="triangle"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--巴士 END-->

                    <!--轮船 START-->
                    <div class="traffic-item <#if vehicleType=='BOAT'>active</#if>">
                        <div class="row">
                            <div class="col w70 module-label">
                                行驶时间：
                            </div>
                            <div class="col w170">
                                <input type="text" class="form-control w30  JS_vehicle_hour" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2"
                                	<#if vehicleType!='BOAT'>disabled</#if>
                                	<#if vehicleType=='BOAT'>value="${vehicleTime[0]!''}"</#if> >
                                小时
                                <input type="text" class="form-control w30  JS_vehicle_minute" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2"
                                	<#if vehicleType!='BOAT'>disabled</#if>
                                	<#if vehicleType=='BOAT'>value="${vehicleTime[1]!''}"</#if> >
                                分钟；
                            </div>
                            <div class="col w70 module-label">
                                行驶距离：
                            </div>
                            <div class="col clearfix">
                                <input type="text" class="form-control w50" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="6"
                                	<#if vehicleType!='BOAT'>disabled</#if>
                                	name="prodRouteDetailVehicleList[0].vehicleKm"  <#if vehicleType=='BOAT'> value = '${routeDetailVehicle.vehicleKm!''}'</#if> >
                                公里
                            </div>
                        </div>

                        <div class="row">
                            <div class="col w70 module-label">
                                交通说明 ：
                            </div>
                            <div class="col">
                                <div class="col JS_textares_box">
                                    <a class="textarea-content-expand JS_textarea_expand" data-text="展开交通说明 <i class='triangle'></i>">
                                        添加交通说明
                                        <i class="triangle"></i>
                                    </a>

                                    <div>
                                        <textarea class="form-control textarea-content" maxlength="500" name='prodRouteDetailVehicleList[0].vehicleDesc'
                                        	<#if vehicleType!='BOAT'>disabled</#if>
                                        	><#if vehicleType=='BOAT'>${routeDetailVehicle.vehicleDesc!''}</#if></textarea>
                                    </div>

                                    <a class="textarea-content-shrink JS_textarea_shrink">
                                        收起交通说明
                                        <i class="triangle"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--轮船 END-->

                    <!--邮轮 START-->
                    <div class="traffic-item <#if vehicleType=='CRUISE'>active</#if>">
                        <div class="row">
                            <div class="col w70 module-label">
                                行驶时间：
                            </div>
                            <div class="col w170">
                                <input type="text" class="form-control w30  JS_vehicle_hour" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2"
                                	<#if vehicleType!='CRUISE'>disabled</#if>
                                	<#if vehicleType=='CRUISE'>value="${vehicleTime[0]!''}"</#if> >
                                小时
                                <input type="text" class="form-control w30  JS_vehicle_minute" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2"
                                	<#if vehicleType!='CRUISE'>disabled</#if>
                                	<#if vehicleType=='CRUISE'>value="${vehicleTime[1]!''}"</#if> >
                                分钟；
                            </div>
                            <div class="col w70 module-label">
                                行驶距离：
                            </div>
                            <div class="col clearfix">
                                <input type="text" class="form-control w50" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="6"
                                	<#if vehicleType!='CRUISE'>disabled</#if>
                                	name="prodRouteDetailVehicleList[0].vehicleKm" <#if vehicleType=='CRUISE'>value = '${routeDetailVehicle.vehicleKm!''}'</#if> >
                                公里
                            </div>
                        </div>

                        <div class="row">
                            <div class="col w70 module-label">
                                交通说明 ：
                            </div>
                            <div class="col">
                                <div class="col JS_textares_box">
                                    <a class="textarea-content-expand JS_textarea_expand" data-text="展开交通说明 <i class='triangle'></i>">
                                        添加交通说明
                                        <i class="triangle"></i>
                                    </a>

                                    <div>
                                        <textarea class="form-control textarea-content" maxlength="500" 
                                        	<#if vehicleType!='CRUISE'>disabled</#if>
                                          name='prodRouteDetailVehicleList[0].vehicleDesc'><#if vehicleType=='CRUISE'>${routeDetailVehicle.vehicleDesc!''}</#if></textarea>
                                    </div>

                                    <a class="textarea-content-shrink JS_textarea_shrink">
                                        收起交通说明
                                        <i class="triangle"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--邮轮 END-->

                    <!--其他 START-->
                    <div class="traffic-item <#if vehicleType=='OTHERS'>active</#if>">
                        <div class="row">
                            <div class="col w70 module-label">
                                交通说明 ：
                            </div>
                            <div class="col">
                                <div class="col JS_textares_box">
                                    <a class="textarea-content-expand JS_textarea_expand" data-text="展开交通说明 <i class='triangle'></i>">
                                        添加交通说明
                                        <i class="triangle"></i>
                                    </a>

                                    <div>
                                        <textarea class="form-control textarea-content" maxlength="500" 
                                            <#if vehicleType!='OTHERS'>disabled</#if>
                                          name='prodRouteDetailVehicleList[0].vehicleDesc'><#if vehicleType=='OTHERS'>${routeDetailVehicle.vehicleDesc!''}</#if></textarea>
                                    </div>

                                    <a class="textarea-content-shrink JS_textarea_shrink">
                                        收起交通说明
                                        <i class="triangle"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--其他 END-->

                </div>
                <!--模块右侧 END-->
            </div>

			 </form>
        </div>
        <!--交通编辑 END-->

        <div class="day-module-add" <#if newStructureFlag=='N'>style="display:none"</#if>  >
            <div class="day-module-add-title">添加行程信息 <i class="triangle"></i></div>
        </div>

    </div>
