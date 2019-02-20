<!--酒店 START-->
<div class="module template-hotel">
	<!--酒店模块头部 START-->
	<div class="module-head clearfix">
        <div class="module-title">住宿</div>
        <div class="module-control">
        	<a class="JS_module_prev">上移</a>
            <a class="JS_module_next">下移</a>
            <a class="JS_module_delete">删除</a>
            <a class="module-btn-edit JS_module_edit">编辑</a>
            <a class="btn btn-save JS_module_save">保存</a>
        </div>
    </div>
    <!--酒店模块头部 END-->
    
    <!--酒店编辑 START-->
    <div class="edit">
    <form>
        <#-- 组隐藏域DIV -->
        <div class="JS_group_form_hidden" style="display:none">
            <#--行程ID-->
            <input type="hidden" name="routeId" />
            <#--行程明细ID-->
            <input type="hidden" name="detailId" />
            <#--组ID-->
            <input type="hidden" name="groupId" />
            <#--开始时间-->
            <input type="hidden" name="startTime" />
            <#--排序值-->
           	<input type="hidden" name="sortValue" />
            <#--模块类型-->
            <input type="hidden" name="moduleType" value="HOTEL"/>
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
                                <input type="checkbox" name="localTimeFlag" value="Y">
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

                </div>
                <div class="hotel-increase">
                    <a class="btn btn-white JS_hotel_increase">
                        <i class="icon-add-item"></i>
                        增加酒店
                    </a>
                </div>

                <div class="row JS_travelType_travelTime_distanceKM">
                    <div class="col w110">
                        <select class="form-control w80 JS_activity_time">
                            <option value="DRIVE">行驶时间</option>
                            <option value="WALK">徒步时间</option>
                        </select>
                    </div>
                    <div class="col w160">
                        <input type="text" class="form-control w30 JS_travel_hour" data-validate="{regular:仅支持输入数字}"
                               data-validate-regular="^\d*$" maxlength="2"/>
                        小时
                        <input type="text" class="form-control w30 JS_travel_minute" data-validate="{regular:仅支持输入数字}"
                               data-validate-regular="^\d*$" maxlength="2"/>
                        分钟；
                    </div>
                    <div class="col module-label w60 JS_activity_distance">
                        行驶距离
                    </div>
                    <div class="col w110">
                        约
                        <input type="text" class="form-control w30 JS_distanceKM" data-validate="{regular:仅支持输入数字}"
                               data-validate-regular="^\d*$" maxlength="4"/>
                        公里；
                    </div>
                </div>
                <div class="row">
                    <div class="col module-label w90">
                        话术模板 <i class="icon icon-help" data-poptip="话术模板可以将你所填的内容整合成较为易懂的一段话"></i> ：
                    </div>
                    <div class="col">
                        <label>
                            <input type="checkbox" class="JS_use_template_flag" name="useTemplateFlag" />
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

    <div class="day-module-add">
        <div class="day-module-add-title">添加行程信息 <i class="triangle"></i></div>
    </div>
</div>
<!--酒店 END-->

<!--一个酒店 START-->
<div class="hotel-item" data-index="" data-id="">

	<#--单个景点下的隐藏域DIV-->
    <div class="JS_item_form_hidden" style="display:none">
         <#--产品ID-->
         <input type="hidden" class="hidden_productId" name="prodRouteDetailHotelList[{{index}}].productId" value=""/>
         <#--逻辑关系-->
         <input type="hidden" class="hidden_logic_relation" name="prodRouteDetailHotelList[{{index}}].logicRelateion" value="" />
         <#--出行类型-->
         <input type="hidden" class="hidden_travel_type" name="prodRouteDetailHotelList[{{index}}].travelType" value="" />
         <#--出行时间-->
         <input type="hidden" class="hidden_travel_time" name="prodRouteDetailHotelList[{{index}}].travelTime" value="" />
          <#--行驶距离-->
         <input type="hidden" class="hidden_distanceKM" name="prodRouteDetailHotelList[{{index}}].distanceKM" value="" />
         <#--是否使用模板-->
         <input type="hidden" class="hidden_useTemplateFlag" name="prodRouteDetailHotelList[{{index}}].useTemplateFlag" value="" />
         <#--模板CODE-->
         <input type="hidden" class="hidden_template_code" name="prodRouteDetailHotelList[{{index}}].templateCode" value="" />
         
    </div>
    
    <!--酒店模块 添加前 START-->
    <div class="hotel-initial">
        <div class="row">
            <div class="col w40 JS_hotel_and_or">
                <select class="form-control w40">
                    <option value="OR">或</option>
                </select>
            </div>
            <div class="col w80 module-label">
                入住酒店 <em class="text-danger">*</em> ：
            </div>
            <div class="col w410">
                <input type="text" class="form-control w390 JS_single_hotel_name" placeholder="请输入酒店名称"
                       maxlength="100" data-validate="{required:true,}"/>
                <input type="hidden" class="JS_hotel_id"/>
            </div>
            <div class="col">
                <input class="btn btn-white JS_hotel_add" value="添加" type="button"
                       data-validate="{regular:请点击添加或删除多余表单}" data-validate-regular="^[^.]$"/>
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
        	<span class="view-and-or hotel-and-or">
        		<select class="form-control w40">
                    <option value="OR">或</option>
                </select>
        	</span>
            <a class="JS_hotel_del">删除</a>
        </div>
        <div class="row">
            <div class="col w70 module-label">
                入住酒店 ：
            </div>
            <div class="col w110 JS_hotel_name">
               <!-- 北京保利大厦酒店-->
               <input type="text" class="form-control w100" style="display:none;" maxlength="100" name="prodRouteDetailHotelList[{{index}}].hotelName" placeholder="输入酒店名称" value="">
            </div>
            <div class="col w60 module-label">
                房型 ：
            </div>
            <div class="col w140 JS_div_hotel_roomType">
            	<!--房型 下拉菜单-->
            	<input type="hidden" name="prodRouteDetailHotelList[{{index}}].roomType" value="" />
                <select class="form-control w110 JS_hotel_roomTypeId" style="display:none;" name="prodRouteDetailHotelList[{{index}}].roomTypeId">
                </select>
                <!--房型输入框-->
                <input type="text" class="form-control w100" style="display:none;" maxlength="100" name="prodRouteDetailHotelList[{{index}}].roomType" placeholder="输入房型" value="">
            </div>
            <div class="col w40 module-label">
                星级 ：
            </div>
            <div class="col w140 div_hotel_starLevel">
            	<input type="hidden" name="prodRouteDetailHotelList[{{index}}].starLevelName" value="" />
                <select class="form-control w110 JS_hotel_starLevel" style="display:none;" name="prodRouteDetailHotelList[{{index}}].starLevel">
                    <option value="-1">不显示星级</option>
                	<#list hotelStarList as hs>
                        <option value="${hs.dictId!''}">${hs.dictName!''}</option>
                    </#list>
                </select>
                <select class="form-control w110 JS_hotel_starLevel" style="display:none;" name="prodRouteDetailHotelList[{{index}}].starLevel">
                    <option value="-1">不显示星级</option>
                	<#list prodStarList as ps>
                        <option value="${ps.dictId!''}">${ps.dictName!''}</option>
                    </#list>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="col module-label w70">
                所在地 ：
            </div>
            <div class="col JS_hotel_belongToPlace">
                <input type="text" class="form-control w190" style="display:none;" name="prodRouteDetailHotelList[{{index}}].belongToPlace" placeholder="请输入酒店所在地" maxlength="50" />
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
                        <textarea class="form-control textarea-content" name="prodRouteDetailHotelList[{{index}}].hotelDesc" maxlength="500"></textarea>
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