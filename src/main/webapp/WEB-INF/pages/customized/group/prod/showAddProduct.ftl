<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>产品商品基本信息</title>

    <#include "/base/head_meta.ftl"/>
    <!-- 目前使用里面Editor相关code -->
    <#include "/base/findProductInputType.ftl"/>

    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/vst-line-travel.css"/>

</head>
<body>
<div class="iframe_header">
    <ul class="iframe_nav">
        <li><a href="#">定制游</a> &gt;</li>
        <li><a href="#">产品维护</a> &gt;</li>
        <li class="active">添加产品</li>
    </ul>
</div>

<div class="iframe_content mt10">
    <div class="tiptext tip-warning"><span class="tip-icon tip-icon-warning"></span>注：产品创建后，不能变更所属的品类</div>
    <div class="p_box box_info">
        <#-- 产品基础From表单 strat-->
        <form id="productFrom">
            <#-- 存放隐藏域 DIV -->
            <div id="productFormHiddenDiv">
                <input type="hidden" id="productId" name="productId">
                <input type="hidden" id="categoryId" name="bizCategoryId" value="42">
                <input type="hidden" id="categoryName" name="bizCategory.categoryName" value="定制游" >
                <#-- 产品是否有效（默认无效）-->
                <input type="hidden" name="cancelFlag" value="N" >
                <#-- 是否存在敏感词 -->
                <input type="hidden" name="senisitiveFlag" value="N">
            </div>

            <div class="box_content info_line">
                <table class="e_table form-inline">
                    <tbody>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>所属品类：</td>
                        <td>定制游</td>
                    </tr>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>产品类型：</td>
                        <td>
                            <select name="productType" class="lt-category js_product_type notNOneTest" data-validate="true" required>
                                <option data-value="addName_default" value="-1">选择产品类别</option>
                                <#list productTypes as productType>
                                    <option value="${productType.code!''}">${productType.cnName!''}</option>
                                </#list>
                            </select>
                            <span class="info-dd-note info-category-note1" >注意：选择产品类别并保存后，不可更改</span>
                            <span class="info-dd-note info-category-note2">请删除当前产品名称再修改产品类别</span>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label e_label_top" width="150"><i class="cc1">*</i>驴妈妈产品名称：</td>
                        <td class="lt-product-name-td">
                        	<input type="text" id="productName" name="productName" class="wl_300 notSymbolTest" data-validate="true" required maxlength="100"/>
                            <span>&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||"</span>
                        </td>
                        <!-- <td class="lt-product-name-td">
                            <a href="javascript:;" class="lt-add-name-btn lt-link-disabled">添加名称</a>
                            <input type="hidden" class="JS_hidden_main_product_name" id="productName" name="productName" value="" data-validate="true" required>
                            <div class="JS_hidden_product_name_vo_div">
                                <input type="hidden" class="JS_hidden_vo_product_name" name="prodProductNameVO.productName" value="">
                                <input type="hidden" class="JS_hidden_vo_large_activity" name="prodProductNameVO.largeActivity" value="">
                                <input type="hidden" class="JS_hidden_vo_promotion_or_hotel" name="prodProductNameVO.promotionOrHotel" value="">
                                <input type="hidden" class="JS_hidden_vo_night_number" name="prodProductNameVO.nightNumber" value="">
                                <input type="hidden" class="JS_hidden_vo_day_number" name="prodProductNameVO.dayNumber" value="">
                                <input type="hidden" class="JS_hidden_vo_play_type" name="prodProductNameVO.playType" value="">
                                <input type="hidden" class="JS_hidden_vo_product_feature" name="prodProductNameVO.productFeature" value="">
                                <input type="hidden" class="JS_hidden_vo_level_star" name="prodProductNameVO.levelStar" value="">
                            	<input type="hidden" class="JS_hidden_vo_theme_content" name="prodProductNameVO.themeContent" value="">
                                
                                
                            </div>
                        </td> -->

                    </tr>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>供应商产品名称：</td>
                        <td>
                            <input type="text" id="suppProductName" name="suppProductName" class="wl_300 notSymbolTest" data-validate="true" required maxlength="100"/>
                            <span>&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||"</span>
                        </td>
                    </tr>
                    <tr>
                        <#-- 该值默认为无效（N），存储值在productFormHiddenDiv隐藏域的input数据框中-->
                        <td class="e_label" width="150"><i class="cc1">*</i>状态：</td>
                        <td>
                            <select class="pginfo_state" disabled data-validate="true" required>
                                <option value="N" selected="selected">无效</option>
                                <option value="Y">有效</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>推荐级别：</td>
                        <td>
                            <select name="recommendLevel" data-validate="true" required>
                                <option value="5">5</option>
                                <option value="4">4</option>
                                <option value="3">3</option>
                                <option value="2" selected="selected">2</option>
                                <option value="1">1</option>
                            </select>
                            <span>说明：由高到低排列，即数字越高推荐级别越高</span>
                        </td>
                    </tr> 
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>打包类型：</td>
                        <td>
                            <#list packageTypeList as list>
                                <input type="radio" name="packageType" value="${list.code!''}" <#if list.code == "SUPPLIER">checked="checked"</#if> onclick="return false;" readonly data-validate="true" required />${list.cnName!''}
                            </#list>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>产品经理：</td>
                        <td>
                            <input type="text" name="managerName" id="managerName" />
                            <input type="hidden" name="managerId" id="managerId" data-validate="true" required>
                            <span id="tips" style="color:red;">注：该处信息仅供参考，如需修改请至商品基础设置下进行维护</span>
                            <div id="managerNameError"></div>
                        </td>
                    </tr>
                  
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>所属分公司：</td>
                        <td>
                            <select name="filiale" class="filialeCombobox"  data-validate="true">
                            	<option value="">请选择</option>
                                <#list filiales as filiale>
                                    <option value="${filiale.code}" >${filiale.cnName}</option>
                                </#list>
                            </select>
                            <div id="filialeError"></div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="box_content info_line">
                <p class="info_title">电子合同</p>
                <table class="e_table form-inline">
                    <tbody>
                    <tr>
                        <td class="e_label" width="150">电子合同范本：</td>
                        <td>
                            <select name="prodEcontract.econtractTemplate" id="econtract">
                                <option >自动调取</option>
                                <option value="COMMISSIONED_SERVICE_AGREEMENT" >委托服务协议</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>组团方式：</td>
                        <td>
                            <input type="radio" name="prodEcontract.groupType" value="SELF_TOUR" data-validate="true" required />自行组团&nbsp;
                            <input type="radio" name="prodEcontract.groupType" value="COMMISSIONED_TOUR" data-validate="true" required />委托组团&nbsp;
                            <label id="label_groupSupplierName" style="display:none;">被委托组团方:</div>
                            <input id="input_groupSupplierName" type="text" name="prodEcontract.groupSupplierName" value="" style="display:none;" />
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="box_content info_line">
                <p class="info_title">基础信息</p>
                <table class="e_table form-inline">
                    <tbody>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>跟团类型：</td>
                        <td>
                            <#list groupTypes as groupType>
                                <input type="radio" name="prodLineBasicInfo.groupType" value="${groupType.code!''}" class="pack_type" data-validate="true" required/><span>${groupType.cnName!''}</span>
                            </#list>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>是否有大交通：</td>
                        <td>
                            <input type="radio" name="prodLineBasicInfo.trafficFlag" value="Y" class="pack_type" traffic="traffic_flag" data-validate="true" required/><span>是</span>
                            <input type="radio" name="prodLineBasicInfo.trafficFlag" value="N" class="pack_type" traffic="traffic_flag"  data-validate="true" required/><span>否</span>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>最少成团人数：</td>
                        <td>
                            <input type="text" name="prodLineBasicInfo.leastClusterPerson" data-validate="true" digits="true" max="1000" required/>人
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label" width="150">儿童价标准描述：</td>
                        <td>
                            <textarea class="lt-child-price-text" name="prodLineBasicInfo.childPriceDesc" maxlength="200"></textarea>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="box_content info_line">
                <p class="info_title">描述信息</p>
               <!--/产品经理推荐-->
                <div>
                    <table class="e_table form-inline addOne_tj">
                        <tbody>
                            <#list 1..2 as num>
                            <tr class='lt-tj'>
                                <td class="e_label" width="150"><#if num_index == 0><i class="cc1">*</i>产品经理推荐：</#if></td>
                                <td><input type="text" name="productRecommends" class="wl_300" style="width:400px;" placeholder="输入产品推荐语，每句话最多输入30个汉字" data-validate="true" required maxlength="30"/>
                                </td>
                            </tr>
                            </#list>
                        </tbody>
                    </table>
                    <p class="add_one_word"><a class="lt-add-tj-btn" href="javascript:;">增加一条</a></p>
                </div>
                <!--/产品经理推荐END-->
    
                <!--/产品详情 START-->
                <!-- <table class="e_table form-inline">
                    <tr class='lt-tj'>
                        <td class="e_label" width="150"><p class="lt-pd-title">产品特色：</p></td>
                        <td>
                        <div class="lt-pd-input">
                            <textarea name="productDetail" class="w35 sensitiveVad textWidth" style="width:500px; height:150px" errorEle="errorEle" mark='sensitiveVad' maxlength="30000"></textarea>
                        </div>
                    </td>
                    </tr>
                </table> -->
                <!--/产品详情 END-->
                
                 <#assign suggGroupIds = [26,27,28,29,30,31,32,33,63]/> 
  			<#assign index=0 />
  			<#assign productId="" />
 			<#list bizCatePropGroupList as bizCatePropGroup>
	            <#if (!suggGroupIds?seq_contains(bizCatePropGroup.groupId)) && bizCatePropGroup.bizCategoryPropList?? && (bizCatePropGroup.bizCategoryPropList?size &gt; 0) >
		            <div class="p_box box_info">
		           <!-- <div class="title">
					    <h2 class="f16"><#if bizCatePropGroup.groupId == 64> <#else>${bizCatePropGroup.groupName!''}：</#if> </h2>
				    </div> -->
		            <div class="box_content">
		            	<table class="e_table form-inline">
		             		<tbody>
			                	<#list bizCatePropGroup.bizCategoryPropList as bizCategoryProp>
			                		<#if bizCategory.categoryId == '15' || bizCategory.categoryId == '16' || bizCategory.categoryId == '17' || bizCategory.categoryId == '18' || bizCategory.categoryId == '42'>
			                		  <#--产品经理推荐-->
				                		<#if bizCategoryProp?? && bizCategoryProp.propCode=='recommend'>
				                		  
                                    	<#assign index=index+1 />
			                			<#else>
					                		<#if (bizCategoryProp??)>
					                		   <#if bizCategoryProp.propCode=='feature'>
						                			<#assign disabled='' />
							                		<#if bizCategoryProp.cancelFlag=='N'>
							                			<#assign disabled='disabled' />
							                		</#if>
							                		<#assign prodPropId='' />
							                		<#assign propId=bizCategoryProp.propId />
							                		<#if bizCategoryProp?? && bizCategoryProp.prodProductPropList[0]!=null>
							                		<#assign prodPropId=bizCategoryProp.prodProductPropList[0].prodPropId />
						                		</#if>
							                	<tr>
								                <td width="150" class="e_label td_top">
								                	<#if bizCategoryProp.nullFlag == 'Y'><span class="notnull">*</span></#if>
								                		${bizCategoryProp.propName!''}
								                	<#if bizCategoryProp.cancelFlag=='N'><span style="color:red" class="cancelProp">[无效]</span></#if>：
								                </td>
							                	<td> <span class="${bizCategoryProp.inputType!''}">     		
							                		<input type="hidden" name="prodProductPropList[${index}].prodPropId" value="${prodPropId}" ${disabled}  />
							                		<input type="hidden" name="prodProductPropList[${index}].propId" value="${propId}" ${disabled} />
							                		<input type="hidden" name="prodProductPropList[${index}].bizCategoryProp.propCode" value="${bizCategoryProp.propCode!''}"/>
							                		 <!-- 調用通用組件 -->
							                		<@displayHtml productId index bizCategoryProp  />
							                		<div id="errorEle${index}Error" style="display:inline"></div>
							                		<span style="color:grey">${bizCategoryProp.propDesc!''}</span>
							        				</span></td>
								        		</tr>
								        		<#assign index=index+1 />
							              	   </#if>
							                 </#if>
						              </#if>
						           <#else>
						           		<#if (bizCategoryProp??)>
					                		<#assign disabled='' />
					                		<#if bizCategoryProp.cancelFlag=='N'>
					                			<#assign disabled='disabled' />
					                		</#if>
					                		<#assign prodPropId='' />
					                		<#assign propId=bizCategoryProp.propId />
					                		<#if bizCategoryProp?? && bizCategoryProp.prodProductPropList[0]!=null>
						                		<#assign prodPropId=bizCategoryProp.prodProductPropList[0].prodPropId />
					                		</#if>
						                	<tr>
							                <td width="150" class="e_label td_top">
							                	<#if bizCategoryProp.nullFlag == 'Y'><span class="notnull">*</span></#if>
							                	${bizCategoryProp.propName!''}
							                	<#if bizCategoryProp.cancelFlag=='N'><span style="color:red" class="cancelProp">[无效]</span></#if>：
							                </td>
						                	<td> <span class="${bizCategoryProp.inputType!''}">     		
						                		<input type="hidden" name="prodProductPropList[${index}].prodPropId" value="${prodPropId}" ${disabled}  />
						                		<input type="hidden" name="prodProductPropList[${index}].propId" value="${propId}" ${disabled} />
						                		<input type="hidden" name="prodProductPropList[${index}].bizCategoryProp.propCode" value="${bizCategoryProp.propCode!''}"/>
						                		 <!-- 調用通用組件 -->
						                		<@displayHtml productId index bizCategoryProp  />
						                		<div id="errorEle${index}Error" style="display:inline"></div>
						                		<span style="color:grey">${bizCategoryProp.propDesc!''}</span>
						        				</span></td>
							        		</tr>
						              	</#if>
						               <#assign index=index+1 />
						           </#if>
		                	</#list>
		                 </tbody>
				       </table>
		            </div>
		        </div>
	        </#if>
		</#list>

            </div>
            
           

            <div class="box_content info_line ">
                  <div class="box_content">
                    <table class="e_table form-inline">
                        <tbody>
                        <tr id="districtTr">
                            <td class="e_label"><i id="districtFlag" class="cc1">*</i>出发地：</td>
                            <td>
                                <input type="text" id="district" name="district" readonly="readonly" class="w35" required>
                                <input type="hidden" id="districtId" name="bizDistrictId" >
                                <div id="districtError"></div>
                            </td>
                        </tr>
                        <tr name='no1'>
                            <td name="addspan" class="e_label"><i class="cc1">*</i>目的地：</td>
                            <td>
                                <input type="text" class="w35" id="dest0" name="dest" readonly = "readonly" required>
                                <input type="hidden" name="prodDestReList[0].destId" id="destId0" />
                                <a class="btn btn_cc1" id="new_button">添加</a>
                                <span type="text" id="spanId_0"></span>
                                <div id="destError"></div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- 销售渠道 -->
            <div class="box_content info_line">
                <#include "/customized/packageTour/product/showDistributorProd.ftl"/>
            </div>

        </form>

            <div class="p_box box_info info_line" id="reservationLimit">
                <div class="title">
                    <h2 class="f16">预订限制</h2>
                </div>
                <#include "/common/reservationLimit.ftl"/>
            </div>

            <a class="gi-button JS_button_save" href="javascript:">保存</a>
            <a class="gi-button JS_button_save_and_next" href="javascript:">保存并维护下一步</a>

    </div>
</div>

<!--/弹出层-->
<div class="baseInfo_bg"></div>
<!--/弹出层END-->

<!-- 引入产品名称模板 -->
<#include "/dujia/group/prod/productNameTemplate.ftl"/>

<!-- 引入基本的js -->
<#include "/base/foot.ftl"/>

<!-- 页面跳转逻辑JS-->
<script src="/vst_admin/js/dujia/dujia-common.js"></script>
<script src="/vst_admin/js/dujia/group/vst-product-info.js"></script>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/kindeditor.js"></script>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/plugins/image/image.js"></script>
<script type="text/javascript" src="/vst_admin/js/contentManage/kindEditorConf.js?v1"></script>

<script>


     var $document = $(document);

    //内容不能是特殊符号（备注：将notSymbolTest值方法要验证的input输入框的class中即可验证）
    jQuery.validator.addMethod("notSymbolTest", function (value, element) {
        var $ele = $(element);
        var val = $ele.val();
        var illegalReg = /[<>%#*&^@!~/\\'||"]/;
        return !illegalReg.test(val);
    }, "禁止输入特殊符号");
    jQuery.validator.addClassRules("notSymbolTest", {
        notSymbolTest: true
    });

    //内容不能是-1
    jQuery.validator.addMethod("notNOneTest", function (value, element) {
        var $ele = $(element);
        var val = $ele.val();
        
        return (val !== "-1");
    }, "该字段不能为空");
    jQuery.validator.addClassRules("notNOneTest", {
        notNOneTest: true
    });

    $document.on("click", ".JS_button_save,.JS_button_save_and_next", function () {

        var $this = $(this);
        var $giForm = $this.parents(".p_box");

        //大表单
        var $forms = $giForm.find("form");

        //去除placeholder
        var $placeholder = $forms.find('[data-validate="true"][data-placeholder]:not([disabled])');
        $placeholder.each(function (index, element) {

            var $ele = $(element);
            var value = $ele.val();
            var placeHolderText = $ele.data("placeholder");

            if (placeHolderText === value) {
                $ele.val("");
            }

        });

        //是否验证通过
        var isValidate = true;

        //行程 表单
        $forms.each(function() {
            var $form = $(this);
            if(validateForm($form) == false) {
                isValidate = false;
            }
        });

        function validateForm($form) {

            var isValidate = true;
            var validate = $form.validate();
            var $input = $form.find('[data-validate="true"]:not([disabled])');

            $input.each(function (index) {
                var $required = $input[index];
                var ret = validate.element($required);
                if (!ret) {
                    isValidate = false;
                }
            });

            //整体控制字数
            var $validateExtend = $form.find('[data-validate-extend="true"]');
            $validateExtend.each(function () {
                var $this = $(this);
                if (validateExtend($this) == false) {
                    isValidate = false;
                }
                $this.off("input propertychange", "input[type=text]", watchExtend);
                $this.on("input propertychange", "input[type=text]", watchExtend);
                function watchExtend() {
                    var $this = $(this);
                    var $extend = $this.parents('[data-validate-extend="true"]');
                    validateExtend($extend);
                }
            })

            return isValidate;
        }
		var filialeName = $("select.filialeCombobox").combobox("getValue");
		if(!filialeName) {
			var $combo = $("select.filialeCombobox").next();
			$("i[for=\"FILIALE\"]").remove();
			$combo.css('border-color', "red");
			$("<i for=\"FILIALE\" class=\"error\">该字段不能为空</i>").insertAfter($combo);
		}

		isValidate = isValidate && !!filialeName;

        //验证通过
        var alertObj;
        if (isValidate) {
            addProduct($(this));
        } else {
            alertObj = $.saveAlert({
                "width": 250,
                "type": "danger",
                "text": "请完成必填填写项并确认填写正确"
            });
        }

    });

    /*           kindEditor（产品特色） JS start                 */
    var dataObj=[],markList=[];

    $(".sensitiveVad").each(function(){
        var mark=$(this).attr('mark');
        var t = lvmamaEditor.editorCreate('mark',mark);
        dataObj.push(t);
        markList.push(mark);
    });

    function validateSensitiveVad(){
        var ret = true;

        $("textarea.sensitiveVad").each(function(index,element){
            var required = $(element).attr("required");
            var str = $(element).text();
            if(required==="required"&&str.replace("<br />","")===""){
                $.alert("请填写完必填项再保存");
                ret= false;
            }

            var len = str.match(/[^ -~]/g) == null ? str.length : str.length + str.match(/[^ -~]/g).length ;
            var maxLength = $(element).attr("maxLength");
            if(len>maxLength){
                $.alert("超过最大长度"+maxLength);
                ret= false;
            }
        });
        return ret;
    }
    /*            kindEditor JS end                 */

    /*            全局常量 JS start                        */
    //出发地窗口（出发地弹出、产品特色editor相关代码在findProductInputType.ftl文件中）
    var districtSelectDialog,contactAddDialog,coordinateSelectDialog;
    /*            全局常量  JS end                        */

    /*            目的地选择 JS start                     */
    var destSelectDialog;
    var dests = [];//子页面选择项对象数组
    var count =0;
    var markDest;
    var markDestId;
    var spanId;

    //选择目的地
    function onSelectDest(params){
        if(params!=null){
            $("#"+markDest).val(params.destName + "[" + params.destType + "]");
            $("#"+markDestId).val(params.destId);
            if(params.parentDest==""){
            $("#"+spanId).html("");
            }else{
            $("#"+spanId).html("上级目的地："+params.parentDest);
            }
        }
        destSelectDialog.close();
        $("#destError").hide();
    }

    //新建目的地
    $document.on("click", "#new_button", function() {
        count++;
        var rows = $("input[name=dest]").size();
        $("td[name=addspan]").attr("rowspan",rows+1);
        var $tbody = $(this).parents("tbody");
        $tbody.append("<tr><td><input type='text' class='w35' name='dest' id='dest"+count+"' readonly = 'readonly' required/>" + 
                        "<input type='hidden' name='prodDestReList["+count+"].destId' id='destId"+count+"'/>&nbsp;" + 
                        "<a class='btn btn_cc1' name='del_button'>删除</a>" + 
						"<span type='text' id='spanId_"+count+"'></span></td></tr>"); 
    });

    //删除目的地
    $document.on("click", "a[name=del_button]", function() {
        if($(this).parents("tr").attr("name")=="no1"){
            var $td = $(this).parents("tr").children("td:first");
            $(this).parents("tr").next().prepend($td);
            $(this).parents("tr").next().attr("name","no1");
            $(this).parents("tr").next().children("td:last").append("<a class='btn btn_cc1' id='new_button'>添加目的地</a>")
        }

        $(this).parents("tr").remove();
        var rows = $("input[name=dest]").size();
        $("td[name=addspan]").attr("rowspan",rows);
    });

    //打开选择行政区窗口
    $document.on("click", "input[name=dest]", function() {
        markDest = $(this).attr("id");
        markDestId = $(this).next().attr("id");
        spanId = $(this).next().next().next().attr("id");
        var url = "/vst_admin/biz/dest/selectDestList.do?type=main";
        destSelectDialog = new xDialog(url,{},{title:"选择目的地",iframe:true,width:"1000",height:"600"});
    });
    /*             目的地选择 JS end                        */

    /*          产品保存 JS start                 */
    function addProduct($this) {

        //检验是否选中分销商
        var distributorChecked = document.getElementById("distributorIds_4").checked;
        if(distributorChecked){
            var distributorUserIds = $("input:checkbox[name='distributorUserIds']:checked").val();
            if(isEmpty(distributorUserIds)){
                $.alert("请选择super系统分销商.");
                return;
            }
        }

        for(var i=0;i<dataObj.length;i++){
            var temp = dataObj[i].html();
            $(".sensitiveVad").filter("[mark="+markList[i]+"]").text(temp);
        }
        $.each( $("input[autoValue='true']"), function(i, n){
            if($(n).val()==""){
                $(n).val($(n).attr('placeholder'));
            }
        });

        $("textarea").each(function(){
            if($(this).text()==""){
                $(this).text($(this).attr('placeholder'));
            }
        });

        //校验当前form表单
        var flag1;
        var flag2;
        if(!$("#productFrom").validate().form()){
            $(this).removeAttr("disabled");
            flag1 = false;
        }

        if(!validateSensitiveVad()){
            return false;
        }

        if(!$("#reservationLimitForm").validate().form()){
            flag2 = false;
        }

        if(flag1 == false || flag2 == false){
            return false;
        }

        //敏感词校验（产品名称、供应商产品名称、产品经理推荐、产品详情）
        var $elements = $("input[name='productName'],input[name='suppProductName'],input[name='productRecommends'],textarea");
        console.log(validateSensitiveWord($elements, false));
        if(validateSensitiveWord($elements, false)){
            $("input[name=senisitiveFlag]").val("Y");
            $.confirm("内容含有敏感词，是否继续？", function() {
                sendAjaxToSaveProduct($this);
            });
        } else {
            $("input[name=senisitiveFlag]").val("N");
            sendAjaxToSaveProduct($this);
        }

    }

    //发送ajax请求保存产品信息
    function sendAjaxToSaveProduct($this) {
        //判断当前按钮的状态
        if($this.data("saving")) {
            return;
        }
        //改变保存按钮状态
        changeSaveButtonStatus(true);

        //移除name="productType"上面的disabled
        $("select[name='productType']").removeAttr("disabled");

        $.ajax({
            url : "/vst_admin/customized/group/product/addProduct.do",
            type : "post",
            dataType : 'json',
            data : $("#productFrom").serialize()+"&"+$("#reservationLimitForm").serialize()+"&comOrderRequiredFlag="+($("#reservationLimitForm").is(":hidden") ? "N" : "Y"),
            success : function(result) {
                if(result.code == "success"){
                    //为子窗口设置productId
                    $("input[name='productId']").val(result.attributes.productId);
                    //为父窗口设置productId
                    $("#productId",window.parent.document).val(result.attributes.productId);
                    $("#productName",window.parent.document).val(result.attributes.productName);
                    $("#categoryName",window.parent.document).val(result.attributes.categoryName);
                    $("#productType",window.parent.document).val(result.attributes.productType);

                    $.saveAlert({"width": 150,"type": "success","text": "保存成功"});
                    if ($this.is(".JS_button_save_and_next")) {
                        $("#route",parent.document).parent("li").trigger("click");
                    } else {
                        parent.checkAndJump();
                    }

                    //刷新产品外层框架
                    refreshProductMainFrame();
                } else {
                    $.saveAlert({"width": 250,"type": "danger","text": result.message});
                }

                changeSaveButtonStatus(false);
            },
            error : function() {
                changeSaveButtonStatus(false);
                console.log("Call sendAjaxToSaveProduct method occurs error");
                $.alert('网络服务异常, 请稍后重试');
            }
        });
    }

    //刷新产品维护主框架
    function refreshProductMainFrame() {
        //判断打包类型，然后更新父页面菜单
        var packageType = $("input[name=packageType]:checked").val();
        $("#packageType", parent.document).val(packageType);
        if("SUPPLIER"==packageType){
            $("#lvmama", parent.document).remove();
            $("#supplier", parent.document).show();
            $("#reservationLimit").show();
        }else if("LVMAMA"==packageType){
            $("#supplier", parent.document).remove();
            $("#lvmama", parent.document).show();
            $("#reservationLimit").hide();
        }else {
            $.alert("打包类型没有!");
        }

        //判断是否有大交通
        var transportType = $("input[name='prodLineBasicInfo.trafficFlag']:checked").val();
        $("#transportType", parent.document).val(transportType);
        if($("input[name='prodLineBasicInfo.trafficFlag']:checked").size() > 0 && "SUPPLIER"==packageType){
            if(transportType == 'Y'){
                $("#transportLi",parent.document).show();
            }else {
                $("#transportLi",parent.document).hide();
            }
        }
    }

    //改变 保存、保存并下一步 按钮的状态（isLoading：true 保存前 false 保存结束后）
    function changeSaveButtonStatus(isLoading) {
        var $saveButton =$(".JS_button_save");
        var $saveButtonNext = $(".JS_button_save_and_next");

        if (isLoading) {
            $saveButton.html("保存中");
            $saveButtonNext.html("保存中");
            $saveButton.attr("data-saving", true);
            $saveButtonNext.attr("data-saving", true);
            $saveButton.addClass("disabled");
            $saveButtonNext.addClass("disabled");
        } else {
            $saveButton.html("保存");
            $saveButtonNext.html("保存并维护下一步");
            $saveButton.attr("data-saving", false);
            $saveButtonNext.attr("data-saving", false);
            $saveButton.removeClass("disabled");
            $saveButtonNext.removeClass("disabled");
        }
    }
    /*           产品保存 JS end                 */

    //模糊查找 产品经理名称及电话
    vst_pet_util.superUserSuggest("#managerName", "input[name=managerId]");

    //当 产品类型 改变时同时改变 预定限制 中的内容
    $("select[name='productType']").live("change", function(){
        var addtion = "";
        showRequire($("input[name='bizCategoryId']").val(),$("select[name=productType]").val(),addtion);
    });

    //控制组团方式为委托组团的被委托组团方是否显示
    $document.on("click", "input:radio[name='prodEcontract.groupType']", function() {
        var val = $('input:radio[name="prodEcontract.groupType"]:checked').val();
        if (val == 'SELF_TOUR') {
            $("#label_groupSupplierName").hide();
            $("#input_groupSupplierName").hide();
            $("#input_groupSupplierName").val("");
        } else {
            $("#label_groupSupplierName").show();
            $("#input_groupSupplierName").show();
        }
    });

    //判断参数为空
    function isEmpty(value) {
        if (typeof(value) == 'undefined' || value == null || value == "") {
            return true;
        } else {
            return false;
        }
    }

$("select.filialeCombobox").combobox({
    multiple:false,
    width: 170,
    filter:function(q,row){
		var opts=$(this).combobox("options");
		return row[opts.textField].indexOf(q) > -1;
	},
	onHidePanel: function () {
		var filialeName = $(this).combobox("getValue");
		if(!!filialeName) {
			$(".combo").css('border-color', "#abc");
			$("i[for=\"FILIALE\"]").css("display", "none");
		}
	}
});

 //交通按钮切换
    $("input[traffic=traffic_flag]").click(function(){
        var that = $(this);
        if(that.attr("checked")=="checked"){
            if(that.val()=="N"){
                $("#districtTr").hide();
                $("#district").hide();
                $("#district").val(null);
                $("#districtId").val(null);
                $("input[value='auto_pack_traffic']").parent().parent().parent().hide();
                $("input[value='isuse_packed_cost_explanation']").parent().parent().parent().hide();
				$("input[value='packed_product_id']").parent().parent().parent().hide();
				$("input[value='isuse_packed_route_details']").parent().parent().parent().hide();
            }else if(that.val()=="Y"){
                $("#districtTr").show();
                $("#district").show();
                $("input[value='auto_pack_traffic']").parent().parent().parent().hide();
                $("input[value='isuse_packed_cost_explanation']").parent().parent().parent().hide();
				$("input[value='packed_product_id']").parent().parent().parent().hide();
				$("input[value='isuse_packed_route_details']").parent().parent().parent().hide();
				
            }
        }
    });

</script>
</body>
</html>

