/**
 * Created by samael on 4/10/16.
 */

var Util = {

    scene: function(layerInstanceOrClass) {
        var scene = cc.Scene.create();
        var layer = layerInstanceOrClass instanceof cc.Layer ? layerInstanceOrClass : new layerInstanceOrClass();
        scene.addChild(layer);
        return scene;
    },

    gid: function() {
        return new Date().getTime().toString() + _.pad(Util.randomInt(0, 1000), 4, '0');
    },


    /**
     * Returns a random real number in [min, max)
     * @nosidesprites
     */
    randomReal: function (min, max) {
        return Math.random() * (max - min) + min;
    },

    /**
     * Returns a random integer in [min, max]
     * Using Math.round() will give you a non-uniform distribution!
     * @nosidesprites
     */
    randomInt: function (min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    },

    /**
     * return true with given rate
     * @param rate: a [0, 1] rate
     */
    randomRate: function (rate) {
        return Math.random() < rate;
    },

    /**
     * random using a probability weight array.
     * eg [50, 25, 25], this function return 0 in 50%, 1 and 2 25% each
     * @nosidesprites
     */
    randomByProbability: function(probabilities) {
        var base = 0;
        for (var i = 0; i < probabilities.length; i++) {
            base += probabilities[i];
        }
        var r = this.randomReal(0, base);
        for (var j = 0, sum = 0; j < probabilities.length; j++) {
            if (r >= sum && r < sum + probabilities[j]) {
                return j;
            }
            sum += probabilities[j];
        }
        return -1;
    },

    randomItem: function(metaObj, filter) {
        var base = 0, sum = 0;
        _.each(metaObj, function(rate, key) {
            if (_.isFunction(filter) && !filter(key)) return;
            base += rate;
        });
        base = base * 10000;
        var r = this.randomReal(0, base);
        for (var id in metaObj) {
            if (_.isFunction(filter) && !filter(id)) continue;
            var next = sum + metaObj[id] * 10000;
            if (r > sum && r <= next) {
                return id;
            }
            sum = next;
        }
        return null;
    },

    randomItemByRate: function(metaObj, key, filter) {
        var base = 0, sum = 0;
        _.each(metaObj, function(item) {
            if (item[key] == undefined) return;
            if (_.isFunction(filter) && !filter(item)) return;
            base += item[key];
        });
        base = base * 10000;
        var r = this.randomReal(0, base);
        for (var id in metaObj) {
            var item = metaObj[id];
            if (_.isFunction(filter) && !filter(item)) continue;
            var next = sum + item[key] * 10000;
            if (r > sum && r <= next) {
                return item;
            }
            sum = next;
        }
        return null;
    },

    positionCompare: function(a, b) {
        var aa = Math.round(a), bb = Math.round(b);
        return aa === bb ? 0 :
            aa  >  bb ? 1 :
                -1;
    },

    isTouchInside: function (touch, node) {
        var touchLocation = node.convertTouchToNodeSpace(touch);
        var width = node.getContentSize().width;
        var height = node.getContentSize().height;
        var touchableRect = cc.rect(0, 0, width, height);
        return cc.rectContainsPoint(touchableRect, touchLocation);
    },

    normalizePoint: function(xOrPoint, y) {
        var x = y !== undefined ? xOrPoint : xOrPoint.x;
        var y = y !== undefined ? y : xOrPoint.y;
        return cc.p(x, y);
    },

    createStencil: function(rect) {
        var stencil = cc.DrawNode.create();
        var color = cc.color(1, 1, 1, 1);
        var verts = [cc.p(rect.x, rect.y), cc.p(rect.x + rect.width, rect.y),
            cc.p(rect.x + rect.width, rect.y + rect.height), cc.p(rect.x, rect.y + rect.height)];
        stencil.drawPoly(verts, color, 1, color);
        return stencil;
    },

    floatEqual: function(a, b, epsilon) {
        return Math.abs(a - b) < epsilon;
    },

    timeDistance: function(far, near) {
        near = near || new Date();
        var d = (near.getTime() - far.getTime()) / 1000;
        if (d < 60) {
            return d + "秒前";
        } else if (d < 3600) {
            return Math.floor(d/60) + "分钟前";
        } else if (d < 86400) {
            return Math.floor(d/3600) + "小时前";
        } else {
            return Math.floor(d/86400) + "天前";
        }
    },
    formatTime: function(ts) {
        function p(s) {
            return s < 10 ? '0' + s: s;
        }
        var _second = 1000;
        var _minute = _second * 60;
        var _hour = _minute * 60;
        var minutes = p(Math.floor((ts % _hour) / _minute));
        var seconds = p(Math.floor((ts % _minute) / _second));
        return minutes + ":"+ seconds;
    },
    within: function(value, limit) {
        if (limit[0] != -1 && value < limit[0]) return false;
        if (limit[1] != -1 && value > limit[1]) return false;
        return true;
    },

    inc: function(obj, key , count) {
        obj[key] = (obj[key] || 0) + (count || 1);
    },


    registerTouchEventOneByOne: function(target, isSwallow, priority) {
        var obj = {
            event: cc.EventListener.TOUCH_ONE_BY_ONE,
            swallowTouches: isSwallow == null ? true : isSwallow,
            onTouchBegan: target.onTouchBegan.bind(target)
        };

        if (target.onTouchMoved) {
            obj.onTouchMoved = target.onTouchMoved.bind(target)
        }

        if (target.onTouchEnded) {
            obj.onTouchEnded = target.onTouchEnded.bind(target)
        }

        if (target.onTouchCanceled) {
            obj.onTouchCanceled = target.onTouchCanceled.bind(target)
        }
        var eventListener = cc.EventListener.create(obj);
        cc.eventManager.addListener(eventListener, priority || target);
        return eventListener
    },

    registerTouchEventAllAtOnce: function(target, isSwallow, priority) {
        var obj = {
            event: cc.EventListener.TOUCH_ALL_AT_ONCE,
            swallowTouches: isSwallow == null ? true : isSwallow,
            onTouchesBegan: target.onTouchesBegan.bind(target)
        };

        if (target.onTouchesMoved) {
            obj.onTouchesMoved = target.onTouchesMoved.bind(target)
        }

        if (target.onTouchesEnded) {
            obj.onTouchesEnded = target.onTouchesEnded.bind(target)
        }

        if (target.onTouchesCanceled) {
            obj.onTouchesCanceled = target.onTouchesCanceled.bind(target)
        }
        var eventListener = cc.EventListener.create(obj);
        cc.eventManager.addListener(eventListener, priority || target);
        return eventListener
    },

    getTriggerNumByTouch: function(touchPos) {
        var tx = touchPos.x;
        var ty = touchPos.y;
        var col = parseInt(tx / (cc.winSize.width / bl.GAME_COL)) + 1;
        var row = parseInt(ty / ((cc.winSize.height - 50) / bl.GAME_ROW)) + 1;
        return col + (row - 1)* bl.GAME_COL;
    },

    // 判断A 是不是 B的子集
    isSubset: function(setA, setB) {
        var flag = true;
        _.each(setA, function(k) {
            flag = flag &&_.include(setB, k);
        });
        return flag;
    }
};

