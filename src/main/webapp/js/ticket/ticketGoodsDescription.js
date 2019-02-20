/**
 *
 * Created by jihongming on 2015/12/16.
 */
function switchItemDisable(item, enable) {
    item.prop('disabled', enable);
}

function enableNeedItem(item) {
    item.prop('disabled', false);
}
function disableItem(item) {
    item.prop('disabled', true);
}
function removeDisabledClass(item) {
    item.removeClass('disabled');
}
function addDisabledClass(item) {
    item.addClass('disabled');
}

function hideOrShowDeleteBtn(td) {
    if (td.children('div').length == 1) {
        td.find('.deleteBtn').hide();
    } else {
        td.find('.deleteBtn').show();
    }
}

function initPage() {
    $('#visitLimitTd, #fetchLimitTd, #defineTd ').each(function() {
        hideOrShowDeleteBtn($(this));
    });
    $('#feeContentTd').children('div').each(function() {
        hideOrShowDeleteBtn($(this));
    });
    buildPageMsg();
}

function isEmptyValue(val) {
    return val == null || val.trim() == "";
}

function isInt(val) {
    return (val.indexOf('.') == -1) && parseInt(val) == val;
}

function isNumber(val) {
    return parseFloat(val) == val;
}

var VALIDATE_END_MAP = {
    detail: {need: true},
    quantity: {need: true, intType: true, min: 1},
    quantifier: {need: true},
    age: {need: true, intType: true, max: 150},
    height: {need: true, floatType: true, max: 3},
    needFetchTicket: {need: true}
};

function checkMax(obj, val, floatFlag) {
    if (obj.max == null) {
        return true;
    }
    var value = floatFlag ? parseFloat(val) : parseInt(val);
    return obj.max >= value;
}

function checkMin(obj, val, floatFlag) {
    if (obj.min == null) {
        return true;
    }
    var value = floatFlag ? parseFloat(val) : parseInt(val);
    return obj.min <= value;
}

function validateObjAndVal(obj, val) {
    if (obj == null) {
        return true;
    }
    if (obj.need && isEmptyValue(val)) {
        return false;
    }
    if (obj.intType) {
        if (!isInt(val)) {
            return false;
        }
        if (! checkMax(obj, val, false) || ! checkMin(obj, val, false)) {
            return false;
        }
    }
    if (obj.floatType) {
        if (! isNumber(val)) {
            return false;
        }
        if (! checkMax(obj, val, true) || ! checkMin(obj, val, true)) {
            return false;
        }
    }
    return true;
}

function validateSubmitTicketDesc() {
    var msg = null;
    $('#feeContentTd').find('input').each(function() {
        var currentInput = $(this);
        var shortName = currentInput.prop('name').replace(/.*\./g, '');
        var val = currentInput.val();
        var obj = VALIDATE_END_MAP[shortName];
        if (! validateObjAndVal(obj, val)) {
            msg = "请检查费用包含输入框内容";
            return false;
        }
    });
    if (msg == null) {
        if ((isEmptyValue($('#visitSite').val()))) {
            msg = "请输入入园地点";
        } else if (isEmptyValue($('#visitLimit').find('input[type=radio]').val())) {
            msg = "请选择入园时间";
        }
    }
    if (msg == null) {
        var checkedFlag = false;
        $('#visitMethodTd').find('div').each(function () {
            var div = $(this);
            var checkbox = div.find('input[type=checkbox]:checked');
            if (checkbox.length > 0) {
                checkedFlag = true;
                var shortName = checkbox.prop('name').replace(/.*\['/g, '').replace(/'.*/g, '');
                if (VISIT_METHOD[shortName].needRemark && isEmptyValue(div.find('input[type=text]').val())) {
                    msg = "请检查入园方式输入框内容";
                    return false;
                }
            }
        });
        if (!checkedFlag) {
            msg = "请至少选中一种入园方式";
        }
    }
    if (msg == null) {
        $('#typeTable').find('tr').each(function () {
            var tr = $(this);
            if (tr.find('th input[type=checkbox]:checked').length > 0) {
                var td = tr.find('td');
                if (td.find('input[type=radio]').length == 0) {
                    if (isEmptyValue(td.find('input').val())) {
                        msg = "请检查票种说明输入框内容";
                        return false;
                    }
                    return true;
                }
                var foundChecked = false;
                var errorFlag = false;
                td.find('div').each(function () {
                    var cDiv = $(this);
                    var radio = cDiv.find('input[type=radio]:checked');
                    if (radio.length > 0) {
                        foundChecked = true;
                        cDiv.find('input[type=text]').each(function () {
                            var currentInput = $(this);
                            var shortName = currentInput.prop('name').replace(/.*\./g, '');
                            var val = currentInput.val();
                            var obj = VALIDATE_END_MAP[shortName];
                            if (!validateObjAndVal(obj, val)) {
                                errorFlag = true;
                                return false;
                            }
                        })
                    }
                    if (errorFlag) {
                        return false;
                    }
                });
                if (!foundChecked) {
                    msg = "请选中单选框";
                    return false;
                }
                if (errorFlag) {
                    msg = "请检查票种说明输入框内容";
                    return false;
                }
            }
        });
    }
    if (msg != null) {
        $.alert(msg);
        return false;
    }

    return true;
}


function buildPageMsg() {
    buildFeeContent();
    buildVisitMethod();
    buildTicketTypeDesc();
    buildVisitLimit();
    buildFetchLimit();
}

function isElNameEndWithDefineName(el, endName) {
    return el.is('[name$='+endName+']');
}

var FEE_NEW_LINE = ['<div class="pb5"><input type="text" maxlength="200" name="feeContents.feeContents[',
        '].detail" class="w260" />+<input type="text" maxlength="5" style="width:20px; " name="feeContents.feeContents[',
        '].quantity" value="1" required/>+<input type="text" maxlength="5" style="width:30px; " name="feeContents.feeContents[',
        '].quantifier" value="张" required/> ( <input type="text" maxlength="400" class="w260" name="feeContents.feeContents[',
        '].remark" placeholder="无，可不填"/> )<a class="fee_add addBtn btn" style="cursor: pointer" data="',
        '">增加</a><a class="fee_delete deleteBtn btn" style="cursor: pointer" data="',
        '">删除</a></div>'];

var DEFINE_NEW_LINE = ['<div class="row"><div class="col"><input type="text" class="form-control w582 mr10" name="typeDesc.defines"></div><a class="define_add addBtn btn" style="cursor: pointer" data="',
    '" >增加</a><a class="define_delete deleteBtn btn" style="cursor: pointer" data="',
    '" >删除</a></div>'];


function getFeeAddLine(size) {
    return combineStrArrayAndSize(FEE_NEW_LINE, size);
}

function getDefineAddLine(size) {
    return combineStrArrayAndSize(DEFINE_NEW_LINE, size);
}

function getVisitAddLine(size) {
    return combineStrArrayAndSize(VISIT_NEW_LINE, size);
}

function getFetchAddLine(size) {
    return combineStrArrayAndSize(FETCH_NEW_LINE, size);
}


function combineStrArrayAndSize(array, size) {
    var str = "";
    for (var i = 0; i < array.length; i++) {
        str += array[i];
        if (i != array.length -1) {
            str += size;
        }
    }
    return str;
}

function copyDivValue(srcDiv, tarDiv) {
    var srcEl = srcDiv.find('input,select');
    var tarEl = tarDiv.find('input,select');
    for (var i = 0; i < srcEl.length; i++) {
        $(tarEl[i]).val($(srcEl[i]).val());
    }
}

function copyTdValue(srcTd, tarTd) {
    var srcDivs = srcTd.find('div');
    var tarDivs = tarTd.find('div');
    for (var i = 0; i < srcDivs.length; i++) {
        copyDivValue($(srcDivs[i]), $(tarDivs[i]));
    }
}

function btnClickHandler(btn) {
    if (btn.hasClass('disabled')) {
        return;
    }
    var sizeData = 0;
    btn.closest('td').find('.btn').each(function(i, item) {
        var btnData = $(item).attr('data');
        if (btnData > sizeData) {
            sizeData = btnData;
        }
    });
    if (sizeData == null || sizeData == "" || sizeData === undefined || sizeData == NaN) {
        sizeData = 0;
    }
    var size = parseInt(sizeData) + 1;
    var sizeChangeFlag = true;
    if (btn.hasClass('fee_add')) {
        btn.closest('div.mb10').append(getFeeAddLine(size));
        var tmp = btn.closest('div.mb10');
        hideOrShowDeleteBtn(tmp);
        buildFeeContent();
    } else if (btn.hasClass('fee_delete')) {
        var tmp = btn.closest('div.mb10');
        btn.closest('div').remove();
        hideOrShowDeleteBtn(tmp);
        buildFeeContent();
    } else if (btn.hasClass('define_add')) {
        btn.closest('td').append(getDefineAddLine(size));
        var tmp = btn.closest('td');
        hideOrShowDeleteBtn(tmp);
        buildTicketTypeDesc();
    } else if (btn.hasClass('define_delete')) {
        var tmp = btn.closest('td');
        btn.closest('div').remove();
        hideOrShowDeleteBtn(tmp);
        buildTicketTypeDesc();
    } else if (btn.hasClass('visit_add')) {
        btn.closest('td').append(getVisitAddLine(size));
        var tmp =btn.closest('td');
        hideOrShowDeleteBtn(tmp);
        buildVisitLimit();
    } else if (btn.hasClass('visit_delete')) {
        var tmp =btn.closest('td');
        btn.closest('div').remove();
        hideOrShowDeleteBtn(tmp);
        buildVisitLimit();
    } else if (btn.hasClass('fetch_add')) {
        btn.closest('td').append(getFetchAddLine(size));
        var tmp = btn.closest('td');
        hideOrShowDeleteBtn(tmp);
        buildFetchLimit();
    } else if (btn.hasClass('fetch_delete')) {
        var tmp = btn.closest('td');
        btn.closest('div').remove();
        hideOrShowDeleteBtn(tmp);
        buildFetchLimit();
    } else if (btn.hasClass('copyVisitSite')) {
        $('#fetchSite').val($('#visitSite').val());
        sizeChangeFlag = false;
    } else if (btn.hasClass('copyVisitLimit')) {
        var visitLimitTd = $('#visitLimitTd');
        var fetchLimitTd = $('#fetchLimitTd');
        fetchLimitTd.children().not('.copyVisitLimit').remove();
        fetchLimitTd.append($(visitLimitTd.html().replace(/visit/g, 'fetch')));
        copyTdValue(visitLimitTd, fetchLimitTd);
        sizeChangeFlag = false;
        buildFetchLimit();
    }
    if (sizeChangeFlag) {
        var wrap = descDialog.dialog.wrap;
        var extraHeight = 35;
        if (btn.hasClass('fee_delete') || btn.hasClass('fee_add')) {
            extraHeight += 22;
        }
        if (btn.hasClass('addBtn')) {
        } else if (btn.hasClass('deleteBtn')) {
            extraHeight = 0 - extraHeight;
        }
        descDialog.dialog.size(wrap.width(), wrap.height() + extraHeight);
        //wrap.height(wrap.height() + extraHeight);
        //var tops = btn.offset().top + $(window).height()/2;
        //console.log(tops);
        //$('html, body').stop();
        //wrap.css({"position": "absolute", "top":  tops});
        //console.log(btn.offset().top);
        ////$('body').stop().scrollTop(btn.offset().top);
        //console.log(btn.offset().top);
    }
}

var LONG_STR = {left: '<p style="text-overflow:ellipsis; white-space:nowrap; width:600px;overflow:hidden">', right: '</p>'};
//var LONG_STR  = {left: '', right: ''};
function buildFeeContent(){
    var feeContents = '';
    var feeDivs = $('#feeContentTd').find("div").eq(0).find("div");
    var feeSize = feeDivs.length;
    //当费用包含只有一条时，不显示序列号“1.”
    if (feeSize == 1) {
        feeDivs.each(function(i){
            $(this).find('input').each(function(j){
                var input = $(this);
                var val = input.val();
                if (j != 3) {
                    if (isEmptyValue(val)) {
                        feeContents = null;
                        return false;
                    }
                    feeContents += val;
                } else {
                    if (!isEmptyValue(val)) {
                        feeContents += '（'+val+'）';
                    }
                }
            });
            if (feeContents == null) {
                return false;
            }
            feeContents += '。';
        });
    }else{
        feeDivs.each(function(i){
            feeContents += (i+1)+'.';
            $(this).find('input').each(function(j){
                var input = $(this);
                var val = input.val();
                if (j != 3) {
                    if (isEmptyValue(val)) {
                        feeContents = null;
                        return false;
                    }
                    feeContents += val;
                } else {
                    if (!isEmptyValue(val)) {
                        feeContents += '（'+val+'）';
                    }
                }
            });
            if (feeContents == null) {
                return false;
            }
            if (i < feeSize-1) {
                feeContents += '；';
            } else {
                feeContents += '。';
            }
            feeContents += '<br>';
        });
    }
    if (feeContents == null) {
        feeContents = "请输入正确的值";
    }
    $('#feeContentShow').html(LONG_STR.left+feeContents + LONG_STR.right);
}

function buildTicketTypeDesc(){
    var ticketInfoTr = $('#dataForm').find("tr").eq(1);
    var ticketType = ticketInfoTr.find("td").eq(0).find(":input").val();
    var ticketInfoDesc = ticketType+"是指";
    var combine = $("#ticketDescCombine").val();
    var combineText;
    if(combine == 'AND'){
        combineText = "且";
    }else{
        combineText = "或";
    }

    var first = true;
    var hasChecked = false;
    var hasValue = false;

    $('#typeTable').find("tr").each(function(i){
        var isCheck = $(this).find("th :input").attr("checked");

        if(isCheck == 'checked'){
            hasChecked = true;
            $(this).find("td").children('div').each(function (){
                var heightAgeDiv = $(this);
                var radioBox = heightAgeDiv.find("input[type=radio]");
                if (radioBox.length > 0) {
                    if (radioBox.is(':checked')) {
                        var oneTicketInfo = "";
                        heightAgeDiv.find("input[type!=radio],select").each(function (i) {
                            var eachInput = $(this);
                            var val = eachInput.val();
                            if (isEmptyValue(val) && ! eachInput.is('[name$=remark]')) {
                                ticketInfoDesc = null;
                                return false;
                            }
                            hasValue = true;
                            if (isElNameEndWithDefineName(eachInput, 'age')) {
                                oneTicketInfo += val;
                                oneTicketInfo += "周岁";
                            } else if (isElNameEndWithDefineName(eachInput, 'height')) {
                                oneTicketInfo += val;
                                oneTicketInfo += "米";
                            } else if (isElNameEndWithDefineName(eachInput, 'includeFlag')) {
                                if (val == 'true') {
                                    oneTicketInfo += "（含）";
                                } else {
                                    oneTicketInfo += "（不含）";
                                }
                            } else if (isElNameEndWithDefineName(eachInput, 'combine')) {
                                if (val == 'TO') {
                                    oneTicketInfo += "~";
                                }
                            } else if (isElNameEndWithDefineName(eachInput, 'upFlag')) {
                                if (val == 'true') {
                                    oneTicketInfo += "以上";
                                } else {
                                    oneTicketInfo += "以下";
                                }
                            } else if (isElNameEndWithDefineName(eachInput, 'remark')) {
                                if (!isEmptyValue(val)) {
                                    oneTicketInfo += "（" + val + "）";
                                }
                            }
                        });
                        if (ticketInfoDesc == null) {
                            return false;
                        }
                        if (!isEmptyValue(oneTicketInfo)) {
                            if (first) {
                                first = false;
                            } else {
                                ticketInfoDesc += combineText;
                            }
                            ticketInfoDesc += oneTicketInfo;
                        }
                    }
                } else {
                    var val = heightAgeDiv.find('input[type=text]').val();
                    if (! isEmptyValue(val)) {
                        if (hasValue) {
                            ticketInfoDesc += combineText;
                        } else {
                            hasValue = true;
                        }
                        ticketInfoDesc += val;
                    }
                }
            });
        }
        if (ticketInfoDesc == null) {
            return false;
        }
    });
    if (ticketInfoDesc == null || !hasChecked || !hasValue) {
        ticketInfoDesc = "请输入正确的值";
    } else {
        ticketInfoDesc += "。";
    }
    $('#ticketTypeDescShow').html(LONG_STR.left + ticketInfoDesc + LONG_STR.right);
}

function buildVisitLimit() {
    buildLimitById('visitLimit', 'visitLimitTd', 'visitLimitShow');
}

function buildFetchLimit() {
    buildLimitById('fetchLimit', 'fetchLimitTd', 'fetchLimitShow');
}

function buildLimitById(tbodyId, tdId, showId){
    var visitLimitInfo='';
    var visitLimit =$('#'+tbodyId);
    if (visitLimit.find('th input[type=radio]:checked').val() == 'N') {
        visitLimitInfo = "无限制";
    } else {
        var first = true;
        $("#"+tdId).find('div').each(function(){
            var oneEnterPartTime='';
            $(this).find('select,input').each(function (i){
                var input = $(this);
                var val = input.val();
                if (isEmptyValue(val) && ! input.is('[name$=remark]')) {
                    visitLimitInfo = null;
                    return false;
                }
                if(i == 0 || i == 2){
                    oneEnterPartTime += val + ":";
                }else if(i == 1){
                    oneEnterPartTime += val + "~";
                }else if(i == 3){
                    oneEnterPartTime += val;
                }else if(i == 4){
                    if (! isEmptyValue(val)) {
                        oneEnterPartTime += "（" + val + "）";
                    }
                }
            });
            if (visitLimitInfo == null) {
                return false;
            }
            if (! isEmptyValue(oneEnterPartTime)) {
                if (first) {
                    first = false;
                } else {
                    visitLimitInfo += "；";
                }
                visitLimitInfo += oneEnterPartTime;
            }
        });
    }
    if (visitLimitInfo == null) {
        visitLimitInfo = "请输入正确的值";
    }
    $('#'+showId).html(LONG_STR.left + visitLimitInfo + LONG_STR.right);
}

var DIRECT_VISIT = "入园";
var VISIT_METHOD = {
    QR_CODE: {left: "凭驴妈妈订单短信中的", right: "", needRemark: true},
    ID_CARD: {left: "凭下单时预留的身份证", right: "", needRemark: false},
    EBK: {left: "凭驴妈妈订单短信中的", right:  "", needRemark: true},
    NEED_PAPER: {left: "打印驴妈妈邮件中的电子确认函，携带纸质凭证和护照", right: "", needRemark: false},
    NO_NEED_PAPER: {left: "凭驴妈妈邮件中的电子确认函（可不用打印，直接出示即可）和护照", right: "", needRemark: false},
    PAPER_AND_FETCH: {left: "打印驴妈妈邮件中的电子确认函，携带纸质凭证和护照至", right: "", needRemark: true},
    DEFINE: {left: "凭", right: "", needRemark: true}
}

function buildVisitMethod() {
    var result = "";
    var first = true;
    $('#visitMethodTd').children('div').each(function() {
        var lineDiv = $(this);
        var inputChecked = lineDiv.find('input:checked');
        var val = lineDiv.find('input[type=text]').val();
        if (inputChecked.length > 0) {
            var shortName = inputChecked.prop('name').replace(/.*\['/g, '').replace(/'.*/g, '');
            if (first) {
                first = false;
            } else {
                result += "；<br>";
            }
            var obj = VISIT_METHOD[shortName];
            if(shortName == 'DEFINE')
            result += (obj.needRemark ? val : "") + obj.right; 	
            else
            result += obj.left + (obj.needRemark ? val : "") + obj.right + DIRECT_VISIT;          
        }
    });
    $('#visitMethodShow').html(result);
}

function switchEnableCopyFetchLimit() {
    var fetchLimit = $('#fetchLimit');
    var copyBtn = fetchLimit.find('.copyVisitLimit');
    if (fetchLimit.find('[name="fetchLimit.limitFlag"]:checked').val() == 'Y'
        &&  $('#visitLimit').find('[name="visitLimit.limitFlag"]:checked').val() == 'Y') {
        removeDisabledClass(copyBtn);
    } else {
        addDisabledClass(copyBtn);
    }
}

$(function() {
    var dataForm = $('#dataForm');
    var typeTable = $('#typeTable');
    $('#ticketDesc').change(function() {
        var isEmpty = isEmptyValue($(this).val());
        typeTable.find('input[type=checkbox]:checked').each(function() {
            var closestTr = $(this).closest('tr');
            var radios = closestTr.find('input[type=radio]');
            if (radios.length > 0) {
                if (radios.is(':checked')) {
                	//如果输入框ticketDesc 当前值为空,则全部禁用;不为空则只允许当前选中行可编辑
                	if(isEmpty){
                        switchItemDisable(radios.parent('div').find('input,select'), isEmpty);
                	}else{
                		 //开启编辑:all radio可编辑
                		 switchItemDisable(radios.parent('div').find('input[type=radio]'), isEmpty); 
                		 //开启编辑:当前选中的 radio checked 所在行编辑内容
                         switchItemDisable(closestTr.find('input[type=radio]:checked').parent('div').find('input[type=text],select'), isEmpty);         
                	}
                }
            } else {
                switchItemDisable(closestTr.find('input[type=text]'), isEmpty);
                var allBtn = closestTr.find('.btn');
                if (isEmpty) {
                    addDisabledClass(allBtn);
                } else {
                    removeDisabledClass(allBtn);
                }
            }
        });

        switchItemDisable(typeTable.find('input[type=checkbox]'), isEmpty);
        switchItemDisable($('#ticketDescCombine'), isEmpty);
        buildTicketTypeDesc();
    });
    dataForm.find('[type=checkbox]').change(function() {
        var checkbox =$(this);
        var parentEl;
        if (isElNameEndWithDefineName(checkbox, 'on')) {
            parentEl = checkbox.closest('div');
        } else {
            parentEl = checkbox.closest('th').siblings('td');
        }
        if (checkbox.is(':checked')) {
            var radios = parentEl.find('input[type=radio]');
            enableNeedItem(radios);
            if (radios.length > 0) {
                radios.each(function(i, item) {
                    var radio = $(item);
                    if (radio.is(':checked')) {
                        enableNeedItem(radio.siblings('input,select'));
                        enableNeedItem(radio.siblings('select'));
                    }
                });
            } else {
                enableNeedItem(parentEl.find('input'));
                removeDisabledClass(parentEl.find('.disabled'))
            }
        } else {
            disableItem(parentEl.find('input[type!=checkbox], select'));
            addDisabledClass(parentEl.find('.btn'))
        }
    });
    dataForm.find('[type=radio]').change(function() {
        var radio =$(this);
        if (radio.is(':checked')) {
            enableNeedItem(radio.siblings('input, select, .btn'));
            if (radio.is('[name$=limitFlag]')) {
                var pTd =radio.closest('tbody').find('td');
                var allOtherEl = pTd.find('select,input[type!=radio]');
                var allBtn = pTd.find('.btn');
                if (radio.val() == "N") {
                    disableItem(allOtherEl);
                    addDisabledClass(allBtn);
                } else {
                    enableNeedItem(allOtherEl);
                    removeDisabledClass(allBtn);
                }
                switchEnableCopyFetchLimit();
            }
            var pDiv = radio.closest('div').siblings('div');
            disableItem(pDiv.find('select,input[type!=radio]'));
            addDisabledClass(pDiv.find('.btn'));
        }
    });
    dataForm.on('click', '.btn', function() {
        btnClickHandler($(this));
    });
    $('#feeContentTd').on('change', 'input' ,function() {
        buildFeeContent();
    });
    $('#visitMethodTd').find('input').change(function() {
        var input = $(this);
        if (input.is('[type=checkbox]')) {
            var extra = 0;
            if (input.is(':checked')) {
                extra = 22;
            } else {
                extra = -22;
            }
            var wrap = descDialog.dialog.wrap;
            descDialog.dialog.size(wrap.width(), wrap.height()+extra);
        }
        buildVisitMethod();
    });
    $('#typeTable').on('change', 'input, select', function() {
        buildTicketTypeDesc();
    });
    $('#visitLimit').on('change', 'input, select', function() {
        var item = $(this);
        if (item.is('[name=visitLimit.limitFlag]')) {
            switchEnableCopyFetchLimit();
        }
        buildVisitLimit();
    });
    $('#fetchLimit').on('change', 'input, select', function() {
        buildFetchLimit();
    });
    initPage();

});
