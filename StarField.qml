import QtQuick 2.8
import QtQuick.Particles 2.8
import QtGraphicalEffects 1.12


Item {
  id: starFieldAF
  width: vpx(1280)
  height: vpx(720)

  ParticleSystem {
      id: particlesystemSmall
      anchors.fill: starFieldAF

      ImageParticle {
          id: stars
          source: "assets/starfield/star.png"
          groups: ["stars"]
          opacity: 0.3
          scale: 1
      }

      Emitter {
          id: starsemitter
          anchors.fill: parent
          emitRate: 100 // parent.width / 10
          lifeSpan: 20000
          lifeSpanVariation: 5000
          startTime: 5000
          group: "stars"
          endSize: vpx(10)
      }
  }

  ParticleSystem {
      id: particlesystemBig
      anchors.fill: parent

      ImageParticle {
          id: starsBig
          source: "assets/starfield/star.png"
          groups: ["starsBig"]
          opacity: 0.8
          scale: 1
      }

      Emitter {
          id: starsemitterBig
          anchors.fill: parent
          emitRate: 5
          lifeSpan: 35000
          lifeSpanVariation: 5000
          startTime: 5000
          group: "starsBig"
          endSize: vpx(15)
      }
  }

  ParticleSystem {
      id: particlesystemBigger
      anchors.fill: parent

      ImageParticle {
          id: starsBigger
          source: "assets/starfield/star.png"
          groups: ["starsBigger"]
          opacity: 1
          scale: 1
      }

      Emitter {
          id: starsemitterBigger
          anchors.fill: parent
          emitRate: 0.2
          lifeSpanVariation: 10000
          lifeSpan: 50000
          startTime: 5000
          group: "starsBigger"
          endSize: vpx(30)
      }
  }
}
