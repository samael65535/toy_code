/**
 * Created by samael on 16/7/5.
 */

var Tension = 0.025;
var Dampening = 0.025;
var Spread = 0.25;
var WaveSpring = cc.DrawNode.extend( {
    m_pos: null,
    m_width: 20,
    m_height: 200,
    speed: 0,
    m_target_height: 200,
    ctor: function(x, y, w, h) {
        this._super();
        this.m_pos = cc.p(x, y);
        this.m_width = w;
        this.m_height = h;
        return true;
    },

    myUpdate: function(dt) {
        this.clear();

        var x = this.m_target_height - this.m_height;
        var tx = this.m_pos.x + this.m_width;
        this.speed += Tension * x - this.speed * Dampening;
        this.m_height += this.speed;

        var ty = this.m_pos.y + this.m_height;
        var drawData = [this.m_pos, cc.p(tx,this.m_pos.y), cc.p(tx, ty), cc.p(this.m_pos.x, ty)];
        this.drawPoly(drawData);
    }
});
var FluidLayer = cc.Layer.extend({
    springs: null,
    leftDeltas: null,
    rightDeltas: null,
    springWidth: 10,
    ctor:function () {
        this._super();
        this.springs = [];
        this.leftDeltas = [];
        this.rightDeltas = [];
        var width = this.springWidth;
        for (var x = 0; x <= cc.winSize.width; x+=width) {
            var node = new WaveSpring(x, 4, width, 200);

            this.addChild(node);
            this.springs.push(node);
        }
        this.scheduleUpdate();

        Util.registerTouchEventOneByOne(this);

        return true;
    },
    onTouchBegan: function(touch) {

        return true;
    },

    onTouchMoved: function(touch) {

        var posX = touch.getLocation().x;
        posX = Math.round(posX / this.springWidth);
        if (this.lastPosX != posX)
            this.splash(posX, -90);
        this.lastPosX = posX;
    },

    onTouchEnded: function(touch) {

    },

    update: function(dt) {
        this.springs.forEach(function (s) {
            s.myUpdate(dt);
        });
        this.leftDeltas = [];
        this.rightDeltas = [];

        // 迭代次数
        for (var j = 0; j < 8; j++) {
            for (var i = 0; i < this.springs.length; i++) {
                if (i > 0) {
                    var s1 = this.springs[i];
                    var s2 = this.springs[i - 1];
                    this.leftDeltas[i] = Spread * (s1.m_height - s2.m_height);
                    s2.speed += this.leftDeltas[i];
                }
                if ( i < this.springs.length - 1) {
                    var s1 = this.springs[i];
                    var s2 = this.springs[i + 1];
                    this.rightDeltas[i] = Spread * (s1.m_height - s2.m_height);
                    s2.speed += this.rightDeltas[i];
                }
            }

            var springs = this.springs;
            var leftDeltas = this.leftDeltas;
            var rightDeltas = this.rightDeltas;

            for (var i = 1; i < springs.length; i++) {
                if (i > 0)
                    springs[i - 1].m_height += leftDeltas[i];

                if ( i < springs.length - 1)
                    springs[i + 1].m_height += rightDeltas[i];

            }
        }
    },

    splash: function(posX, speed) {
        var index = posX;
        for (var i = Math.max(0, index - 0); i < Math.min(this.springs.length - 1, index + 1); i++) {
            this.springs[index].speed = speed;
        }
    }
});

var FluidTestScene = cc.Scene.extend({
    onEnter:function () {
        this._super();
        var layer = new FluidLayer();
        this.addChild(layer);
    }

});