<!--购物 START-->
<div class="module template-shop">

    <div class="module-head clearfix">
        <div class="module-title">购物点</div>

        <div class="module-control">
        	<a class="JS_module_prev">上移</a>
            <a class="JS_module_next">下移</a>
            <a class="JS_module_delete">删除</a>
            <a class="module-btn-edit JS_module_edit">编辑</a>
            <a class="btn btn-save JS_module_save">保存</a>
        </div>
    </div>

    <!--购物编辑 START-->
    <div class="edit">
	  <form>
	  	<#-- 组隐藏域DIV -->
        <div class="JS_group_form_hidden" style="display:none">
            <#--行程ID-->
            <input type="hidden" name="routeId" />
            <#--行程明细ID-->
            <input type="hidden" name="detailId" />
            <#--开始时间-->
            <input type="hidden" name="startTime" />
            <#--模块类型-->
            <input type="hidden" name="moduleType" value="SHOPPING"/>
            <#--排序顺序-->
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

                <div class="shop-list">

                </div>
                <div class="shop-increase">
                    <a class="btn btn-white JS_shop_increase">增加购物点</a>
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
<!--购物 END-->

<!--一个购物点 START-->
<div class="shop-item view-shop-item" data-index="" data-id="">

    <#--单个购物点下的隐藏域DIV-->
    <div class="JS_item_form_hidden" style="display:none">
         <#--主键ID-->
         <input type="hidden" class="hidden_shopping_id" name="prodRouteDetailShoppingList[{{index}}].shoppingId" value=""/>
         <#--名称ID-->
         <input type="hidden" class="hidden_shopping_name_id" name="prodRouteDetailShoppingList[{{index}}].destId" value=""/>
         <#--名称-->
         <input type="hidden" class="hidden_shopping_name" name="prodRouteDetailShoppingList[{{index}}].shoppingName" value="" />
         <#--逻辑关系-->
         <#--<input type="hidden" class="hidden_logic_relation" name="prodRouteDetailShoppingList[{{index}}].logicRelation" value="" />-->
         <#--出行时间-->
         <input type="hidden" class="hidden_travel_time" name="prodRouteDetailShoppingList[{{index}}].travelTime" value="" />
         <#--参观时间-->
         <input type="hidden" class="hidden_visit_time" name="prodRouteDetailShoppingList[{{index}}].visitTime" value="" />
         <#--模板CODE-->
         <input type="hidden" class="hidden_template_code" name="prodRouteDetailShoppingList[{{index}}].templateCode" value="CODE_DEFAULT" />
    </div>

    <!--景点模块 添加前 START-->
    <div class="shop-initial">
        <div class="row">
            <div class="col w40 JS_shop_and_or">
                <select class="form-control w40">
                    <option value="OR">或</option>
                    <option value="AND">和</option>
                </select>
            </div>
            <div class="col w70 module-label">
                购物点 <em class="text-danger">*</em> ：
            </div>
            <div class="col w410">
                <input type="text" class="form-control w390 JS_shop_name" placeholder="请输入购物点名称，禁止输入【】（）<>"
                       maxlength="100" data-validate="{required:true,}"/>
            </div>
            <div class="col">
                <input class="btn btn-white JS_shop_add" value="添加" type="button"
                       data-validate="{regular:请点击添加或删除多余表单}" data-validate-regular="^[^.]$"/>
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
        	<div class="col w40 JS_shop_and_or">
                <select class="form-control w40" name="prodRouteDetailShoppingList[{{index}}].logicRelation" >
                    <option value="OR">或</option>
                    <option value="AND">和</option>
                </select>
            </div>
            <a class="JS_shop_del">删除</a>
        </div>
        <div class="row">
            <div class="col w70 module-label">
                购物点 ：
            </div>
            <div class="col w380 JS_shop_name">
                
            </div>
            <div class="col">
                <label>
                    <input type="checkbox" name="prodRouteDetailShoppingList[{{index}}].recommendFlag" value='Y'/>
                    推荐购物点
                </label>
            </div>
        </div>
        <div class="row">
            <div class="col module-label w70">
                <em>*</em>地址 ：
            </div>
            <div class="col">
                <input type="text" class="form-control w310" data-validate="{required:true}"  maxlength="100" name="prodRouteDetailShoppingList[{{index}}].address" />
            </div>

        </div>
        <div class="row">
            <div class="col module-label w70">
                 <em>*</em>主营产品：
            </div>
            <div class="col w220">
                <input type="text" class="form-control w180" data-validate="{required:true}" maxlength="100" name="prodRouteDetailShoppingList[{{index}}].mainProducts"/>
            </div>
            <div class="col module-label w70">
                兼营产品 ：
            </div>
            <div class="col">
                <input type="text" class="form-control w180" maxlength="100" name="prodRouteDetailShoppingList[{{index}}].subjoinProducts"/>
            </div>

        </div>
        <div class="row">
            <div class="col w110">
                <select class="form-control w80 JS_activity_time" name="prodRouteDetailShoppingList[{{index}}].travelType">
                    <option value="DRIVE">行驶时间</option>
                    <option value="WALK">徒步时间</option>
                </select>
            </div>
            <div class="col w160">
                 约
                <input type="text" class="form-control w30 JS_travel_hour" data-validate="{regular:仅支持输入数字}" data-validate-regular="^\d*$" maxlength="2"/>
                小时
                <input type="text" class="form-control w30 JS_travel_minute" data-validate="{regular:仅支持输入数字}" data-validate-regular="^\d*$" maxlength="2"/>
                分钟
            </div>
            <div class="col module-label w60 JS_activity_distance">
                行驶距离
            </div>
            <div class="col w110">
                约
                <input type="text" class="form-control w30" data-validate="{regular:仅支持输入数字}"
                       data-validate-regular="^\d*$" maxlength="4"  name="prodRouteDetailShoppingList[{{index}}].distanceKM"/>
                公里；
            </div>
            <div class="col module-label w70">
                <em>*</em>参观时间：
            </div>
            <div class="col">
                 约
                <input type="text" class="form-control w30 JS_visit_hour" data-validate="{regular:仅支持输入数字,required:true}" data-validate-regular="^\d*$" maxlength="2"/>
                小时
                <input type="text" class="form-control w30 JS_visit_minute" data-validate="{regular:仅支持输入数字,required:true}" data-validate-regular="^\d*$" maxlength="2"/>
                分钟
            </div>
        </div>
        <div class="row">
            <div class="col module-label w90">
                话术模板 <i class="icon icon-help" data-poptip="话术模板可以将你所填的内容整合成较为易懂的一段话"></i> ：
            </div>
            <div class="col">
                <label>
                    <input type="checkbox" class="JS_use_template_flag" checked="checked" name="prodRouteDetailShoppingList[{{index}}].useTemplateFlag" value="Y"/>
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
                        <textarea class="form-control textarea-content" maxlength="500"  name="prodRouteDetailShoppingList[{{index}}].shoppingDesc">购物自愿，敬请保留相关购物凭证。</textarea>
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
<!--一个购物点 END-->