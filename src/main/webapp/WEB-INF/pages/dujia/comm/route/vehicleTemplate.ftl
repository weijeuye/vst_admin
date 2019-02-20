<div class="module template-traffic">

        <div class="module-head clearfix">
            <div class="module-title">交通</div>

            <div class="module-control">
            	<a class="JS_module_prev">上移</a>
            	<a class="JS_module_next">下移</a>
                <a class="JS_module_delete">删除</a>
                <a class="module-btn-edit JS_module_edit">编辑</a>
                <a class="btn btn-save JS_module_save">保存</a>
            </div>
        </div>

        <!--交通查看 START-->
        <div class="view"> </div>
        <!--交通查看 END-->

        <!--交通编辑 START-->
        <div class="edit">
			<form>
			<#-- 隐藏域用来放隐藏Input -->
	        <div class="JS_group_form_hidden">
	            <input type="hidden" name="routeId" value="${prodLineRoute.lineRouteId}"/>
	            <input type="hidden" name="detailId" />
	            <input type="hidden" name="groupId" />
	            <input type="hidden" name="startTime" />
	            <input type="hidden" name="moduleType" value='VEHICLE'/>
	            <input type="hidden" name="sortValue" />
	            <input type='hidden' name='productId' value="${prodLineRoute.productId}"/>
	        </div>
            <div class="clearfix">
                <!--模块左侧 START-->
                <div class="module-side">
                    <div class="row">
                        <div class="col module-label w70"><em>*</em>开始时间：</div>
                        <div class="col">
                            <p>
                                <span class="JS_time_input">
                                    <span class="JS_time_about w20 inline-block">约</span><input type="text" class="form-control hourWidth JS_time_hour" placeholder="小时" data-validate="{required:true}" maxlength="2">
                                    <span class="JS_time_blank">:</span>
                                    <input type="text" class="form-control hourWidth JS_time_minute" placeholder="分钟" data-validate="{required:true}" maxlength="2">
                                </span>
                            </p>

                            <p>
                                <label class="inline-block">
                                    <input type="checkbox"   name="localTimeFlag" value='Y'>
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
               			<input type="hidden" class="hidden_vehicle_time" name="prodRouteDetailVehicleList[0].vehicleTime" />
               			<input type="hidden" name="prodRouteDetailVehicleList[0].groupId" />
               			<input type="hidden" name="prodRouteDetailVehicleList[0].vehicleId" />
                	</div>
                    <div class="row">
                        <div class="col module-label w70"><em>*</em>交通类型：</div>
                        <div class="col form-group">
                            <label class="mr10">
                                <input data-validate="{required:true}" class="traffic-tab" type="radio" 
                                	value='PLANE' name="prodRouteDetailVehicleList[0].vehicleType">
                                飞机
                            </label>
                            <label class="mr10">
                                <input data-validate="{required:true}" class="traffic-tab" type="radio" 
                                	value='TRAIN' name="prodRouteDetailVehicleList[0].vehicleType">
                                火车
                            </label>
                            <label class="mr10">
                                <input data-validate="{required:true}" class="traffic-tab" type="radio" 
                                	value='BARS' name="prodRouteDetailVehicleList[0].vehicleType">
                                巴士
                            </label>
                            <label class="mr10">
                                <input data-validate="{required:true}" class="traffic-tab" type="radio" 
                                	value='BOAT' name="prodRouteDetailVehicleList[0].vehicleType">
                                轮船
                            </label>
                            <label class="mr10">
                                <input data-validate="{required:true}" class="traffic-tab" type="radio" 
                                	value='CRUISE' name="prodRouteDetailVehicleList[0].vehicleType">
                                邮轮
                            </label>
                            <label class="mr10">
                                <input data-validate="{required:true}" class="traffic-tab" type="radio" 
                                	value='OTHERS' name="prodRouteDetailVehicleList[0].vehicleType">
                                其他
                            </label>
                            <input type="text" class="form-control w200 JS_traffic_other_details" disabled="disabled"
                            	maxlength="50"
                            	data-validate="{required:true}"
                            	name="prodRouteDetailVehicleList[0].vehicleOtherInfo">
                        </div>
                    </div>

                    <!--飞机 START-->
                    <div class="traffic-item">
                        <div class="row">
                            <div class="col w70 module-label"><#if flightTimeValidate == 'Y'><em>*</em><#else></#if>
                                飞行时间：
                            </div>
                            <div class="col w170">
                                <input type="text" class="form-control w30 JS_vehicle_hour JS_vehicle_hour_blur" <#if flightTimeValidate == 'Y'>data-validate="{required:true,regular:true}"<#else>data-validate="{regular:true}"</#if> data-validate-regular="^\d*$" maxlength="2">
                                小时
                                <input type="text" class="form-control w30 JS_vehicle_minute JS_vehicle_minute_blur" <#if flightTimeValidate == 'Y'>data-validate="{required:true,regular:true}"<#else>data-validate="{regular:true}"</#if> data-validate-regular="^\d*$" maxlength="2">
                                分钟；
                            </div>
                            <div class="col w70 module-label">
                                行驶距离：
                            </div>
                            <div class="col clearfix">
                                <input type="text" class="form-control w50" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="6"
                                	name="prodRouteDetailVehicleList[0].vehicleKm">
                                公里
                            </div>
                        </div>
                        <div class="row">
                            <div class="col w70 module-label">
                                接机服务 ：
                            </div>
                            <div class="col traffic-label">
                                <label><input class="form-control traffic-form-control-input" type="checkbox" 
                                	name="prodRouteDetailVehicleList[0].pickUpFlag" value='Y'>接机人员第</label>
                                <select class="form-control traffic-form-control" name="prodRouteDetailVehicleList[0].pickUpDay">
                            		<#list 1..real_route_Num as day_index>
                            			<option value="${day_index}">${day_index}</option>
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
                                        	name='prodRouteDetailVehicleList[0].vehicleDesc'></textarea>
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
                    <div class="traffic-item">
                        <div class="row">
                            <div class="col w70 module-label">
                                行驶时间：
                            </div>
                            <div class="col w170">
                                <input type="text" class="form-control w30 JS_vehicle_hour" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2">
                                小时
                                <input type="text" class="form-control w30 JS_vehicle_minute" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2">
                                分钟；
                            </div>
                            <div class="col w70 module-label">
                                行驶距离：
                            </div>
                            <div class="col clearfix">
                                <input type="text" class="form-control w50" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="6"
                                	name="prodRouteDetailVehicleList[0].vehicleKm">
                                公里
                            </div>
                        </div>
                        <div class="row">
                            <div class="col w70 module-label">
                                接车服务 ：
                            </div>
                            <div class="col traffic-label">
                                <label><input class="form-control traffic-form-control-input" type="checkbox"
                                	 name="prodRouteDetailVehicleList[0].pickUpFlag"  value='Y'>接车人员第</label>
                                <select class="form-control traffic-form-control" name="prodRouteDetailVehicleList[0].pickUpDay">
                            		<#list 1..real_route_Num as day_index>
                            			<option value="${day_index}">${day_index}</option>
                            		</#list>
                                </select>
                                天接车
                            </div>
                        </div>
                        <div class="row">
                            <div class="col w80 module-label">
                                交通说明 ：
                            </div>
                            <div class="col">
                                <div class="col JS_textares_box">
                                    <a class="textarea-content-expand JS_textarea_expand" data-text="展开交通说明 <i class='triangle'></i>">
                                        添加交通说明
                                        <i class="triangle"></i>
                                    </a>

                                    <div>
                                        <textarea class="form-control textarea-content" maxlength="500" name='prodRouteDetailVehicleList[0].vehicleDesc'></textarea>
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
                    <div class="traffic-item">
                        <div class="row">
                            <div class="col w70 module-label">
                                行驶时间：
                            </div>
                            <div class="col w170">
                                <input type="text" class="form-control w30 JS_vehicle_hour" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2">
                                小时
                                <input type="text" class="form-control w30 JS_vehicle_minute" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2">
                                分钟；
                            </div>
                            <div class="col w70 module-label">
                                行驶距离：
                            </div>
                            <div class="col clearfix">
                                <input type="text" class="form-control w50" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="6"
                                	name="prodRouteDetailVehicleList[0].vehicleKm">
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
                                        <textarea class="form-control textarea-content" maxlength="500" name='prodRouteDetailVehicleList[0].vehicleDesc'></textarea>
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
                    <div class="traffic-item">
                        <div class="row">
                            <div class="col w70 module-label">
                                 行驶时间：
                            </div>
                            <div class="col w170">
                                <input type="text" class="form-control w30 JS_vehicle_hour" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2">
                                小时
                                <input type="text" class="form-control w30 JS_vehicle_minute" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2">
                                分钟；
                            </div>
                            <div class="col w70 module-label">
                                行驶距离：
                            </div>
                            <div class="col clearfix">
                                <input type="text" class="form-control w50" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="6"
                                	name="prodRouteDetailVehicleList[0].vehicleKm">
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
                                        <textarea class="form-control textarea-content" maxlength="500" name='prodRouteDetailVehicleList[0].vehicleDesc'></textarea>
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
                    <div class="traffic-item">
                        <div class="row">
                            <div class="col w70 module-label">
                                 行驶时间：
                            </div>
                            <div class="col w170">
                                <input type="text" class="form-control w30 JS_vehicle_hour" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2">
                                小时
                                <input type="text" class="form-control w30 JS_vehicle_minute" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2">
                                分钟；
                            </div>
                            <div class="col w70 module-label">
                                行驶距离：
                            </div>
                            <div class="col clearfix">
                                <input type="text" class="form-control w50" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="6"
                                	name="prodRouteDetailVehicleList[0].vehicleKm">
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
                                        <textarea class="form-control textarea-content" maxlength="500" name='prodRouteDetailVehicleList[0].vehicleDesc'></textarea>
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
                    <div class="traffic-item">
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
                                        <textarea class="form-control textarea-content" maxlength="500" name='prodRouteDetailVehicleList[0].vehicleDesc'></textarea>
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

        <div class="day-module-add">
            <div class="day-module-add-title">添加行程信息 <i class="triangle"></i></div>
        </div>

    </div>
