<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>设置适用酒店</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/lv/calendar.css,/styles/lv/buttons.css,/styles/lv/dialog.css,/styles/lv/icons.css">
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/vst/gallery/v1/reset.css,/styles/backstage/vst/gallery/v1/flat.css,/styles/backstage/vst/gallery/v1/gallery-backstage/display.css">
    <!-- 新添加-->
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/vst/gallery/v1/resources.css">
</head>
<body class="reManage mybody">
<div class="main">
    <div class="hotel-set-box" style="display: block">
        <div class="display-filter">
            <form id="searchHotelForm">
                <div class="cf hotel-condition">
                    <label class="condition-btn"><input type="radio" name="check-condition" checked>按设置条件查询</label>
                    <dl class="cf">
                        <dt>星级标准</dt>
                        <dd>
                            <select name="starLevel" class="form-control require-con require-con-box">
                                <option value="0">-请选择-</option>
                                <option value="5">豪华型酒店</option>
                                <option value="4">品质型酒店</option>
                                <option value="3">舒适型酒店</option>
                                <option value="2">简约型酒店</option>
                                <option value="1">其他</option>
                            </select>
                        </dd>
                    </dl>
                    <dl class="cf">
                        <dt>酒店好评率</dt>
                        <dd>
                            <select name="goodComments" class="form-control require-con require-con-box">
                                <option value="0">-请选择-</option>
                                <option value="99">好评率≥ 99%</option>
                                <option value="98">好评率≥ 98%</option>
                                <option value="97">好评率≥ 97%</option>
                                <option value="96">好评率≥ 96%</option>
                                <option value="95">好评率≥ 95%</option>
                                <option value="94">好评率≥ 94%</option>
                                <option value="93">好评率≥ 93%</option>
                                <option value="92">好评率≥ 92%</option>
                                <option value="91">好评率≥ 91%</option>
                                <option value="90">好评率≥ 90%</option>
                            </select>
                        </dd>
                    </dl>
                    <!--<dl class="cf">
                        <dt>推荐级别</dt>
                        <dd>
                            <select name="priority" class="form-control require-con require-con-box">
                                <option value="0">-请选择-</option>
                                <option value="5">5星</option>
                                <option value="4">4星</option>
                                <option value="3">3星</option>
                                <option value="2">2星</option>
                                <option value="1">1星</option>
                            </select>
                        </dd>
                    </dl>-->
                </div>
                <div class="cf hotel-condition disabled-box">
                    <label class="condition-btn"><input type="radio" name="check-condition">按酒店信息查询</label>
                    <dl class="cf">
                        <dt>酒店名称</dt>
                        <dd>
                            <input type="text" name="hotelName" placeholder="请输入酒店名称" class="form-control js-boat-select require-con" disabled="disabled">
                        </dd>
                    </dl>
                    <dl class="cf">
                        <dt>酒店id</dt>
                        <dd>
                            <input  onkeyup="value=value.replace(/[^\d]/g,'')" maxlength="11" type="text" name="hotelId" id="hotelId" placeholder="请输入酒店id" class="form-control js-boat-select require-con" disabled="disabled">
                        </dd>
                    </dl>
                </div>
                <div class="search-hotel-btn">
                    <a class="btn btn-blue">查询</a>
                </div>
            </form>
        </div>
        <div id="hotelBoxResult"></div>
        <div class="save-hotel-btn">
            <a data-timeid=${hotelTimeId} class="btn btn-blue js-sure-choose">确定选择</a>
        </div>
    </div>
</div>
<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/v1/common.js,/js/lv/dialog.js,/js/lv/calendar.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/vst/gallery/v1/gallery-backstage/display.js"></script>
<script src="http://pic.lvmama.com/js/backstage/vst/gallery/v1/resources.js"></script>
<script src="http://pic.lvmama.com/js/backstage/vst/gallery/v1/resources.js"></script>
<script type="text/javascript" src="/vst_admin/js/superfreetour/searchHotel.js"></script>
<script>

</script>
</body>
</html>