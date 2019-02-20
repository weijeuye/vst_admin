<#if prodTraffic?? && prodTraffic.toType=='FLIGHT'>
	<#assign to_traffic_name = '飞机'/>
</#if>
<#if prodTraffic?? && prodTraffic.toType=='TRAIN'>
	<#assign to_traffic_name = '火车'/>
</#if>
<#if prodTraffic?? && prodTraffic.toType=='BUS'>
	<#assign to_traffic_name = '汽车'/>
</#if>
<#if prodTraffic?? && prodTraffic.toType=='SHIP'>
	<#assign to_traffic_name = '轮船'/>
</#if>

<#if prodTraffic?? && prodTraffic.backType=='FLIGHT'>
	<#assign back_traffic_name = '飞机'/>
</#if>
<#if prodTraffic?? && prodTraffic.backType=='TRAIN'>
	<#assign back_traffic_name = '火车'/>
</#if>
<#if prodTraffic?? && prodTraffic.backType=='BUS'>
	<#assign back_traffic_name = '汽车'/>
</#if>
<#if prodTraffic?? && prodTraffic.backType=='SHIP'>
	<#assign back_traffic_name = '轮船'/>
</#if>

<!--模板使用 开始-->
<div class="lp-template JS_template">

    <!--选项卡 开始-->
    <div class="lp-tab active">
        <span></span>
        <em class="lp-close"></em>
    </div>
    <!--选项卡 结束-->

    <!--交通 开始-->
    <div class="lp-content active JS_traffic" data="" type="TRAFFIC">
        <div class="line_route_select" name="line_route_select">

        </div>
        <div class="lp-delete">
            <a class="btn btn_cc1 JS_btn_delete">删除交通信息</a>
        </div>
        <div name="to">
	        	<!-- 去程Item -->
	            <div class="JS_item_go_box"></div>
	
				<!-- 去程中转Items -->
	            <div class="lp-items JS_items_go_transits"></div>
	            
	            <!-- 添加去程中转Item -->
	            <#if prodTraffic?? && prodTraffic.toType ??>
		        <div class="operate">
	            	<a class="btn btn_cc1 JS_btn_add_transit" data-type="GO" data-template="JS_${prodTraffic.toType?lower_case}_transit"><#if prodTraffic.toType=='BUS'>添加上车点<#else>添加中转${to_traffic_name!''}</#if></a>
	    		</div>
				</#if>
        </div>
        <div name="back">
				<!-- 返程Item -->
	            <div class="lp-item JS_item_return_box"></div>
	            
	            <!-- 反程中转Items -->
	            <div class="lp-items JS_items_return_transits"></div>
	            
	            <!-- 添加返程中转Item -->
	            <#if prodTraffic?? && prodTraffic.backType ??>
                <div class="operate">
		            <a class="btn btn_cc1 JS_btn_add_transit" data-type="RETURN" data-template="JS_${prodTraffic.backType?lower_case}_transit"><#if prodTraffic.backType=='BUS'>添加上车点<#else>添加中转${back_traffic_name!''}</#if></a>
		        </div>
		        </#if>
        </div>
    </div>
    <!--交通 结束-->


    <!-- 行程选择 开始-->
    <div class="suitable_line_route_div_template">
        <td class="e_label">适用行程：</td>
        <td class="suitable_line_route_td">
            <#if prodLineRouteList?? && prodLineRouteList?size gt 0>
                <#list prodLineRouteList as lineRoute>
                    <#if lineRoute.cancleFlag=='Y'>
                        <#-- 有效-->
                        <input type="checkbox" class="selectLineRouteCk" name="selectLineRouteCk" value=${lineRoute.lineRouteId} > ${lineRoute.routeName} &nbsp;&nbsp;
                    <#else>
                        <#-- 无效-->
                        <input type="checkbox" class="selectLineRouteCk" name="selectLineRouteCk" value=${lineRoute.lineRouteId} > ${lineRoute.routeName} <i style="color: red">（无效）</i> &nbsp;&nbsp;
                    </#if>
                </#list>
            </#if>
        </td>
    </div>
    <!-- 行程选择 结束-->

    <!--飞机 去 开始-->
    <div class="lp-item JS_flight_go" name="template_flight" data="" type="FLIGHT">
        <h6 class="lp-title">去程飞机</h6>

		<form>
        <p class="lp-info operate">

            <label>
                <i class="cc1">*</i>航班号
                <input type="text" name="flightNo"/>
                <input type="hidden" name="isFill" value="N">
            </label>
            <a class="btn btn_cc1 JS_btn_complete" name="fill_flight">补全</a>
            <a class="btn btn_cc1 JS_btn_has_not_reference" data="Y">无参考航班</a>
			<#list cabins as cabin>
	            <label class="lp-pr20">
                	<input class="lp-radio" type="radio" name="cabin" value=${cabin.code!''} <#if 'ECONOMY'==cabin.code>checked=checked</#if>/>${cabin.cnName!''}
            	</label>
            </#list>
        </p>
		</form>

        <table class="lp-table JS_has_reference">
            <colgroup>
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
            </colgroup>
            <tbody>
            <tr>
                <th>出发机场</th>
                <td><span name="startAirport"></span></td>
                <th>出发时间</th>
                <td><span name="startTime"></span></td>
                <th>航班号</th>
                <td><span name="flightNo"></span></td>
            </tr>
            <tr>
                <th>到达机场</th>
                <td><span name="arriveAirport"></span></td>
                <th>到达时间</th>
                <td><span name="arriveTime"></span></td>
                <th>航空公司</th>
                <td><span name="airline"></span></td>
            </tr>
            <tr>
                <th>出发航站楼</th>
                <td><span name="startTerminal"></span></td>
                <th>预计耗时</th>
                <td><span name="flightTime"></span></td>
                <th>机型</th>
                <td><span name="airplane"></span></td>
            </tr>
            <tr>
                <th>到达航站楼</th>
                <td><span name="arriveTerminal"></span></td>
                <th>是否经停</th>
                <td><span name="isStop"></span></td>
                <th></th>
                <td></td>
            </tr>
            <tr>
                <th>航班出发地</th>
                <td><span name="startDistrict"></span></td>
                <th>航班目的地</th>
                <td><span name="arriveDistrict"></span></td>
                <th></th>
                <td></td>
            </tr>
            </tbody>
        </table>

        <table class="lp-table JS_has_not_reference" style="width:750px;">
            <colgroup>
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
            </colgroup>
            <tbody>
            <tr>
                <th>航班出发地</th>
                <td>
                    <div class="lp-search-box">
                    	<input type="text" class="lp-w156" name="fromCity" readonly="readonly" value=""/>
                    	<input type="hidden" name="fromCityHidden" value=""/>
                    	<div name="error"></div>
                    </div>
                </td>
                <th>航班目的地</th>
                <td>
                    <div class="lp-search-box">
                    	<input type="text" class="lp-w156" name="toCity" readonly="readonly" value=""/>
                    	<input type="hidden" name="toCityHidden" value=""/>
                    	<div name="error"></div>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>

    </div>
    <!--飞机 去 结束-->

    <!--飞机 返回 开始-->
    <div class="lp-item JS_flight_return" name="template_flight" data="" type="FLIGHT">
        <h6 class="lp-title">返程飞机</h6>

	   <form>
       <p class="lp-info operate">

            <label>
                <i class="cc1">*</i>航班号
                <input type="text" name="flightNo"/>
                <input type="hidden" name="isFill" value="N">
            </label>
            <a class="btn btn_cc1 JS_btn_complete" name="fill_flight">补全</a>
            <a class="btn btn_cc1 JS_btn_has_not_reference" data="Y">无参考航班</a>
            
			<#list cabins as cabin>
	            <label class="lp-pr20">
                	<input class="lp-radio" type="radio" name="cabin" value=${cabin.code!''} <#if 'ECONOMY'==cabin.code>checked=checked</#if>/>${cabin.cnName!''}
            	</label>
            </#list>
            
        </p>
        </form>

        <table class="lp-table JS_has_reference">
            <colgroup>
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
            </colgroup>
            <tbody>
            <tr>
                <th>出发机场</th>
                <td><span name="startAirport"></span></td>
                <th>出发时间</th>
                <td><span name="startTime"></span></td>
                <th>航班号</th>
                <td><span name="flightNo"></span></td>
            </tr>
            <tr>
                <th>到达机场</th>
                <td><span name="arriveAirport"></span></td>
                <th>到达时间</th>
                <td><span name="arriveTime"></span></td>
                <th>航空公司</th>
                <td><span name="airline"></span></td>
            </tr>
            <tr>
                <th>出发航站楼</th>
                <td><span name="startTerminal"></span></td>
                <th>预计耗时</th>
                <td><span name="flightTime"></span></td>
                <th>机型</th>
                <td><span name="airplane"></span></td>
            </tr>
            <tr>
                <th>到达航站楼</th>
                <td><span name="arriveTerminal"></span></td>
                <th>是否经停</th>
                <td><span name="isStop"></span></td>
                <th></th>
                <td></td>
            </tr>
            <tr>
                <th>航班出发地</th>
                <td><span name="startDistrict"></span></td>
                <th>航班目的地</th>
                <td><span name="arriveDistrict"></span></td>
                <th></th>
                <td></td>
            </tr>
            </tbody>
        </table>

        <table class="lp-table JS_has_not_reference" style="width:750px;">
            <colgroup>
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
            </colgroup>
            <tbody>
            <tr>
                <th>航班出发地</th>
                <td>
                    <div class="lp-search-box">
                    	<input type="text" class="lp-w156" name="fromCity" readonly="readonly" value=""/>
                    	<input type="hidden" name="fromCityHidden" value=""/>
                    	<div name="error"></div>
                    </div>
                </td>
                <th>航班目的地</th>
                <td>
                    <div class="lp-search-box">
                     	<input type="text" class="lp-w156" name="toCity" readonly="readonly" value=""/>
                    	<input type="hidden" name="toCityHidden" value=""/>
                    	<div name="error"></div>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>

    </div>
    <!--飞机 返回 结束-->

    <!--飞机 中转 开始-->
    <div class="lp-item JS_flight_transit" name="template_flight" data="" type="FLIGHT">
        <h6 class="lp-title operate">中转飞机 <a class="btn btn_cc1 JS_btn_del_transit">删除</a></h6>

		<form>
       <p class="lp-info operate">

            <label>
                <i class="cc1">*</i>航班号
                <input type="text" name="flightNo"/>
                <input type="hidden" name="isFill" value="N">
            </label>
            <a class="btn btn_cc1 JS_btn_complete" name="fill_flight">补全</a>
            <a class="btn btn_cc1 JS_btn_has_not_reference" data="Y">无参考航班</a>
            
			<#list cabins as cabin>
	            <label class="lp-pr20">
                	<input class="lp-radio" type="radio" name="cabin" value=${cabin.code!''} <#if 'ECONOMY'==cabin.code>checked=checked</#if>/>${cabin.cnName!''}
            	</label>
            </#list>
            
        </p>
        </form>

        <table class="lp-table JS_has_reference">
            <colgroup>
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
            </colgroup>
            <tbody>
            <tr>
                <th>出发机场</th>
                <td><span name="startAirport"></span></td>
                <th>出发时间</th>
                <td><span name="startTime"></span></td>
                <th>航班号</th>
                <td><span name="flightNo"></span></td>
            </tr>
            <tr>
                <th>到达机场</th>
                <td><span name="arriveAirport"></span></td>
                <th>到达时间</th>
                <td><span name="arriveTime"></span></td>
                <th>航空公司</th>
                <td><span name="airline"></span></td>
            </tr>
            <tr>
                <th>出发航站楼</th>
                <td><span name="startTerminal"></span></td>
                <th>预计耗时</th>
                <td><span name="flightTime"></span></td>
                <th>机型</th>
                <td><span name="airplane"></span></td>
            </tr>
            <tr>
                <th>到达航站楼</th>
                <td><span name="arriveTerminal"></span></td>
                <th>是否经停</th>
                <td><span name="isStop"></span></td>
                <th></th>
                <td></td>
            </tr>
            <tr>
                <th>航班出发地</th>
                <td><span name="startDistrict"></span></td>
                <th>航班目的地</th>
                <td><span name="arriveDistrict"></span></td>
                <th></th>
                <td></td>
            </tr>
            </tbody>
        </table>

        <table class="lp-table JS_has_not_reference" style="width:750px;">
            <colgroup>
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
            </colgroup>
            <tbody>
            <tr>
                <th>航班出发地</th>
                <td>
                    <div class="lp-search-box">
                     	<input type="text" class="lp-w156" name="fromCity" readonly="readonly" value=""/>
                    	<input type="hidden" name="fromCityHidden" value=""/>
                    	<div name="error"></div>
                    </div>
                </td>
                <th>航班目的地</th>
                <td>
                    <div class="lp-search-box">
                     	<input type="text" class="lp-w156" name="toCity" readonly="readonly" value=""/>
                    	<input type="hidden" name="toCityHidden" value=""/>
                    	<div name="error"></div>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>

    </div>
    <!--飞机 中转 结束-->
    
    <!--火车 去 开始-->
    <div class="lp-item JS_train_go" name="template_train" data="" type="TRAIN">
        <h6 class="lp-title">去程火车</h6>

        <p class="lp-info operate">

            <label>
                <i class="cc1">*</i>车次号
                <input type="text" name="trainNo"/>
                <input type="hidden" name="isFill" value="N">
                <input type="hidden" name="trainStopList">
            </label>
            <a class="btn btn_cc1 JS_btn_complete" name="fill_train">补全</a>
            <a class="btn btn_cc1 JS_btn_has_not_reference" data="Y">无参考车次</a>
            
        </p>

        <table class="lp-table JS_has_reference">
            <colgroup>
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
            </colgroup>
            <tbody>
            <tr>
                <th>出发车站</th>
                <td><select name="startStation"></select></td>
                <th>出发时间</th>
                <td><span name="startTime"></span></td>
                <th>车次号</th>
                <td><span name="trainNo"></span></td>
            </tr>
            <tr>
                <th>到达车站</th>
                <td><select name="arriveStation"></select></td>
                <th>到达时间</th>
                <td><span name="arriveTime"></span></td>
                <th>坐席</th>
                <td><select name="trainSeat"></select></td>
            </tr>
            <tr>
                <th>始发站</th>
                <td><span name="startStationName"></span></td>
                <th>终点站</th>
                <td><span name="arriveStationName"></span></td>
                <th>运行时长</th>
                <td><span name="allTime"></span></td>
            </tr>
            <tr>
                <th>出发城市</th>
                <td><span name="fromCity"></span></td>
                <th>到达城市</th>
                <td><span name="toCity"></span></td>
                <th></th>
                <td></td>
            </tr>
            </tbody>
        </table>

        <table class="lp-table JS_has_not_reference" style="width:750px;">
            <colgroup>
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
            </colgroup>
            <tbody>
            <tr>
                <th>火车出发地</th>
                <td>
                    <div class="lp-search-box">
                     	<input type="text" class="lp-w156" name="fromCity" readonly="readonly" value=""/>
                    	<input type="hidden" name="fromCityHidden" value=""/>
                    	<div name="error"></div>
                    </div>
                </td>
                <th>火车目的地</th>
                <td>
                    <div class="lp-search-box">
                     	<input type="text" class="lp-w156" name="toCity" readonly="readonly" value=""/>
                    	<input type="hidden" name="toCityHidden" value=""/>
                    	<div name="error"></div>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>

    </div>
    <!--火车 去 结束-->

    <!--火车 返回 开始-->
    <div class="lp-item JS_train_return" name="template_train" data="" type="TRAIN">
        <h6 class="lp-title">返程火车</h6>

        <p class="lp-info operate">

            <label>
                <i class="cc1">*</i>车次号
                <input type="text" name="trainNo"/>
                <input type="hidden" name="isFill" value="N">
                <input type="hidden" name="trainStopList">
            </label>
            <a class="btn btn_cc1 JS_btn_complete" name="fill_train">补全</a>
            <a class="btn btn_cc1 JS_btn_has_not_reference" data="Y">无参考车次</a>
            
        </p>

        <table class="lp-table JS_has_reference">
            <colgroup>
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
            </colgroup>
            <tbody>
            <tr>
                <th>出发车站</th>
                <td><select name="startStation"></select></td>
                <th>出发时间</th>
                <td><span name="startTime"></span></td>
                <th>车次号</th>
                <td><span name="trainNo"></span></td>
            </tr>
            <tr>
                <th>到达车站</th>
                <td><select name="arriveStation"></select></td>
                <th>到达时间</th>
                <td><span name="arriveTime"></span></td>
                <th>坐席</th>
                <td><select name="trainSeat"></select></td>
            </tr>
            <tr>
                <th>始发站</th>
                <td><span name="startStationName"></span></td>
                <th>终点站</th>
                <td><span name="arriveStationName"></span></td>
                <th>运行时长</th>
                <td><span name="allTime"></span></td>
            </tr>
            <tr>
                <th>出发城市</th>
                <td><span name="fromCity"></span></td>
                <th>到达城市</th>
                <td><span name="toCity"></span></td>
                <th></th>
                <td></td>
            </tr>
            </tbody>
        </table>

        <table class="lp-table JS_has_not_reference" style="width:750px;">
            <colgroup>
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
            </colgroup>
            <tbody>
            <tr>
                <th>火车出发地</th>
                <td>
                    <div class="lp-search-box">
                     	<input type="text" class="lp-w156" name="fromCity" readonly="readonly" value=""/>
                    	<input type="hidden" name="fromCityHidden" value=""/>
                    	<div name="error"></div>
                    </div>
                </td>
                <th>火车目的地</th>
                <td>
                    <div class="lp-search-box">
                     	<input type="text" class="lp-w156" name="toCity" readonly="readonly" value=""/>
                    	<input type="hidden" name="toCityHidden" value=""/>
                    	<div name="error"></div>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>

    </div>
    <!--火车 返回 结束-->

    <!--火车 中转 开始-->
    <div class="lp-item JS_train_transit" name="template_train" data="" type="TRAIN">
        <h6 class="lp-title operate">中转火车 <a class="btn btn_cc1 JS_btn_del_transit">删除</a></h6>

        <p class="lp-info operate">

            <label>
                <i class="cc1">*</i>车次号
                <input type="text" name="trainNo"/>
                <input type="hidden" name="isFill" value="N">
                <input type="hidden" name="trainStopList">
            </label>
            <a class="btn btn_cc1 JS_btn_complete" name="fill_train">补全</a>
            <a class="btn btn_cc1 JS_btn_has_not_reference" data="Y">无参考车次</a>
            
        </p>

        <table class="lp-table JS_has_reference">
            <colgroup>
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
                <col class="lp-w16p">
            </colgroup>
            <tbody>
            <tr>
                <th>出发车站</th>
                <td><select name="startStation"></select></td>
                <th>出发时间</th>
                <td><span name="startTime"></span></td>
                <th>车次号</th>
                <td><span name="trainNo"></span></td>
            </tr>
            <tr>
                <th>到达车站</th>
                <td><select name="arriveStation"></select></td>
                <th>到达时间</th>
                <td><span name="arriveTime"></span></td>
                <th>坐席</th>
                <td><select name="trainSeat"></select></td>
            </tr>
            <tr>
                <th>始发站</th>
                <td><span name="startStationName"></span></td>
                <th>终点站</th>
                <td><span name="arriveStationName"></span></td>
                <th>运行时长</th>
                <td><span name="allTime"></span></td>
            </tr>
            <tr>
                <th>出发城市</th>
                <td><span name="fromCity"></span></td>
                <th>到达城市</th>
                <td><span name="toCity"></span></td>
                <th></th>
                <td></td>
            </tr>
            </tbody>
        </table>

        <table class="lp-table JS_has_not_reference" style="width:750px;">
            <colgroup>
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
            </colgroup>
            <tbody>
            <tr>
                <th>火车出发地</th>
                <td>
                    <div class="lp-search-box">
                     	<input type="text" class="lp-w156" name="fromCity" readonly="readonly" value=""/>
                    	<input type="hidden" name="fromCityHidden" value=""/>
                    	<div name="error"></div>
                    </div>
                </td>
                <th>火车目的地</th>
                <td>
                    <div class="lp-search-box">
                     	<input type="text" class="lp-w156" name="toCity" readonly="readonly" value=""/>
                    	<input type="hidden" name="toCityHidden" value=""/>
                    	<div name="error"></div>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>

    </div>
    <!--火车 中转 结束-->

   <!--汽车 去 开始-->
    <div class="lp-item JS_bus_go" name="template_bus" data="" type="BUS">
        <h6 class="lp-title">去程汽车 <a class="btn btn_cc1 JS_btn_del_transit">删除</a></h6>

        <table class="lp-table JS_has_reference">
            <colgroup>
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
            </colgroup>
            <tbody>
            <tr>
                <th><i class="cc1">*</i>上车点</th>
                <td><input type="text" name="adress" value=""></td>
                <th><i class="cc1">*</i>发车时间</th>
                <td>
	                <select id="startTimeHour" name="startTimeHour" style="width:70px;">
	       					<option value=""></option>
	       				<#list 0..23 as startTimeHour>
	            			<!-- <option value="${startTimeHour}">${startTimeHour}</option> -->
	            			<option value="<#if startTimeHour < 10 >${0}${startTimeHour}<#else>${startTimeHour}</#if>"><#if startTimeHour < 10>${0}${startTimeHour}<#else>${startTimeHour}</#if></option>
	       				</#list>
					</select> : 
					<select id="startTimeMinute" name="startTimeMinute" style="width:70px;">
	       					<option value=""></option>
	       				<#list 0..59 as startTimeMinute>
	            			<option value="<#if startTimeMinute < 10 >${0}${startTimeMinute}<#else>${startTimeMinute}</#if>"><#if startTimeMinute < 10>${0}${startTimeMinute}<#else>${startTimeMinute}</#if></option>
	       				</#list>
					</select>
				</td>
            </tr>
            <tr>
                <th>备注</th>
                <td colspan="3"><input type="text" name="memo" style="width:754px;" value=""></td>
            </tr>
            </tbody>
        </table>

    </div>
    <!--汽车 去 结束-->

    <!--汽车 返回 开始-->
    <div class="lp-item JS_bus_return" name="template_bus" data="" type="BUS">
        <h6 class="lp-title">返程汽车 <a class="btn btn_cc1 JS_btn_del_transit">删除</a></h6>

        <table class="lp-table JS_has_reference">
            <colgroup>
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
            </colgroup>
            <tbody>
            <tr>
                <th><i class="cc1">*</i>上车点</th>
                <td><input type="text" name="adress" value=""></td>
                <th><i class="cc1">*</i>发车时间</th>
                <td>
	                <select id="startTimeHour" name="startTimeHour" style="width:70px;">
	       					<option value=""></option>
	       				<#list 0..23 as startTimeHour>
	            			<!-- <option value="${startTimeHour}">${startTimeHour}</option> -->
	            			<option value="<#if startTimeHour < 10 >${0}${startTimeHour}<#else>${startTimeHour}</#if>"><#if startTimeHour < 10>${0}${startTimeHour}<#else>${startTimeHour}</#if></option>
	       				</#list>
					</select> : 
					<select id="startTimeMinute" name="startTimeMinute" style="width:70px;">
	       					<option value=""></option>
	       				<#list 0..59 as startTimeMinute>
	            			<option value="<#if startTimeMinute < 10 >${0}${startTimeMinute}<#else>${startTimeMinute}</#if>"><#if startTimeMinute < 10>${0}${startTimeMinute}<#else>${startTimeMinute}</#if></option>
	       				</#list>
					</select>
				</td>
            </tr>
            <tr>
                <th>备注</th>
                <td colspan="3"><input type="text" name="memo" style="width:754px;" value=""></td>
            </tr>
            </tbody>
        </table>

    </div>
    <!--汽车 返回 结束-->

    <!--汽车 中转 开始-->
    <div class="lp-item JS_bus_transit" name="template_bus" data="" type="BUS">
        <h6 class="lp-title operate">上车点 <a class="btn btn_cc1 JS_btn_del_transit">删除</a></h6>

        <table class="lp-table JS_has_reference">
            <colgroup>
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
            </colgroup>
            <tbody>
            <tr>
                <th><i class="cc1">*</i>上车点</th>
                <td><input type="text" name="adress" value=""></td>
                <th><i class="cc1">*</i>发车时间</th>
                <td>
	                <select id="startTimeHour" name="startTimeHour" style="width:70px;">
	       					<option value=""></option>
	       				<#list 0..23 as startTimeHour>
	            			<!-- <option value="${startTimeHour}">${startTimeHour}</option> -->
	            			<option value="<#if startTimeHour < 10 >${0}${startTimeHour}<#else>${startTimeHour}</#if>"><#if startTimeHour < 10>${0}${startTimeHour}<#else>${startTimeHour}</#if></option>
	       				</#list>
					</select> : 
					<select id="startTimeMinute" name="startTimeMinute" style="width:70px;">
	       					<option value=""></option>
	       				<#list 0..59 as startTimeMinute>
	            			<option value="<#if startTimeMinute < 10 >${0}${startTimeMinute}<#else>${startTimeMinute}</#if>"><#if startTimeMinute < 10>${0}${startTimeMinute}<#else>${startTimeMinute}</#if></option>
	       				</#list>
					</select>
				</td>
            </tr>
            <tr>
                <th>备注</th>
                <td colspan="3"><input type="text" name="memo" style="width:754px;" value=""></td>
            </tr>
            </tbody>
        </table>

    </div>
    <!--汽车  中转 结束-->

    <!--轮船 去 开始-->
    <div class="lp-item JS_ship_go" name="template_ship" data='' type="SHIP">
        <h6 class="lp-title">去程轮船</h6>

        <table class="lp-table JS_has_reference">
            <colgroup>
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
            </colgroup>
            <tbody>
            <tr>
                <th><i class="cc1">*</i>出发地</th>
                <td><input type="text" name="fromAddress" value=""></td>
                <th><i class="cc1">*</i>目的地</th>
                <td><input type="text" name="toAddress" value=""></td>
            </tr>
            <tr>
                <th>备注</th>
                <td colspan="3"><input type="text" name="memo" style="width:754px;" value=""></td>
            </tr>
            </tbody>
        </table>
    </div>
    <!--轮船 去 结束-->

    <!--轮船 返回 开始-->
    <div class="lp-item JS_ship_return"  name="template_ship" data='' type="SHIP">
        <h6 class="lp-title">返程轮船</h6>

        <table class="lp-table JS_has_reference">
            <colgroup>
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
            </colgroup>
            <tbody>
            <tr>
                <th><i class="cc1">*</i>出发地</th>
                <td><input type="text" name="fromAddress" value=""></td>
                <th><i class="cc1">*</i>目的地</th>
                <td><input type="text" name="toAddress" value=""></td>
            </tr>
            <tr>
                <th>备注</th>
                <td colspan="3"><input type="text" name="memo" style="width:754px;" value=""></td>
            </tr>
            </tbody>
        </table>

    </div>
    <!--轮船 返回 结束-->

    <!--轮船 中转 开始-->
    <div class="lp-item JS_ship_transit"  name="template_ship" data='' type="SHIP">
        <h6 class="lp-title operate">中转轮船<a class="btn btn_cc1 JS_btn_del_transit">删除</a></h6>

        <table class="lp-table JS_has_reference">
            <colgroup>
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
                <col class="lp-w25p">
            </colgroup>
            <tbody>
            <tr>
                <th><i class="cc1">*</i>出发地</th>
                <td><input type="text" name="fromAddress" value=""></td>
                <th><i class="cc1">*</i>目的地</th>
                <td><input type="text" name="toAddress" value=""></td>
            </tr>
            <tr>
                <th>备注</th>
                <td colspan="3"><input type="text" name="memo" style="width:754px;" value=""></td>
            </tr>
            </tbody>
        </table>

    </div>
    <!--轮船  中转 结束-->
</div>
<!--脚本模板使用结束-->