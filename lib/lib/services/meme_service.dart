import 'dart:math';

class MemeService {
  static final Random _random = Random();
  
  static String getMemeForExpense(double amount, String category) {
    final memes = _getMemesForAmount(amount);
    return memes[_random.nextInt(memes.length)];
  }
  
  static List<String> _getMemesForAmount(double amount) {
    if (amount < 10) {
      return [
        "🤡 Bro spent less than \$10 and thought he's being responsible!",
        "💀 My grandma finds more money in her couch cushions!",
        "🐷 That's not an expense, that's pocket change!",
        "😅 Congratulations! You spent less than a pizza!",
        "🎮 That's like 1 hour of gaming - you'll survive!",
        "🍬 You could've bought 20 candy bars with that! Diabetes incoming!",
        "☕ That's exactly 2.5 coffees. You're welcome.",
        "📱 That's 1/100th of an iPhone. Almost there!",
        "🚗 That's 0.01 gallons of gas. Better walk!",
        "💈 That's half a haircut. Hope you like the mullet!",
        "🎟️ That's 1/5 of a movie ticket. Watch the trailer instead!",
      ];
    } else if (amount < 50) {
      return [
        "💸 \$${amount.toStringAsFixed(2)}? That's 3 days of coffee! You okay bro?",
        "🍕 You could've bought 2 large pizzas with that! Priorities!",
        "🎬 That's like 4 movie tickets... or 1 movie with snacks!",
        "😭 Your wallet is crying, but not too loud yet!",
        "📱 That's a new phone case... but you bought WHAT?",
        "🎮 That's an indie game on Steam. Hope it was worth it!",
        "🍔 That's 10 McDonald's burgers. Ronald McDonald is proud!",
        "📚 That's 2-3 books. At least you're learning?",
        "🎵 That's 6 months of Spotify. Time to cancel the subscription!",
        "🧥 That's a nice shirt. Too bad you bought something else!",
        "🐶 That's 5 bags of dog food. Your dog is eating better than you!",
      ];
    } else if (amount < 100) {
      return [
        "😱 \$${amount.toStringAsFixed(2)}?! Your wallet just called you a disappointment!",
        "🎮 That's a whole AAA game! Was it worth it?",
        "🍽️ That's 10 meals at McDonald's! Ronald McDonald thanks you!",
        "💀 Your bank account just posted a sad violin song!",
        "🤡 Congratulations! You're now broke but ✨fancy✨!",
        "👟 That's a new pair of Nikes. At least you'll look good being broke!",
        "🎁 That's a birthday present... for yourself?",
        "🍷 That's a fancy dinner. Your stomach is happy, wallet is not!",
        "⚡ That's 2 months of electricity. Hope you like the dark!",
        "🏋️ That's a gym membership you'll use twice. Gains? More like pains!",
        "🎂 That's a cake big enough for 20 people. Who's coming over?",
      ];
    } else if (amount < 500) {
      return [
        "🚨 \$${amount.toStringAsFixed(2)} ALERT! 🚨 Your wallet is filing a police report!",
        "💀 Your bank account just went into witness protection!",
        "😭 Mr. Bank Account: 'I'm tired boss'",
        "🏦 The bank just flagged you for 'questionable life choices'!",
        "🎉 Congratulations! You've unlocked the 'Broke but Happy' achievement!",
        "📱 That's a new mid-range phone. Your old one is crying!",
        "✈️ That's a round-trip ticket to somewhere. Hope you're going!",
        "🛋️ That's a new couch. Your back thanks you, your wallet doesn't!",
        "💻 That's a decent laptop. Working from home just got expensive!",
        "⌚ That's a smartwatch. Now you can track how fast your money disappears!",
        "🎮 That's a gaming console. Say goodbye to productivity!",
        "👗 That's a designer outfit. Fashion is pain (for your wallet)!",
        "🍽️ That's 20 fancy restaurant meals. Chef's kiss to your bank account!",
      ];
    } else if (amount < 1000) {
      return [
        "⚠️ \$${amount.toStringAsFixed(2)}?! Jeff Bezos just felt a disturbance in the force!",
        "💀 Your wallet: 'I don't feel so good Mr. Stark...'",
        "🏦 The bank just sent you a 'thoughts and prayers' card!",
        "😱 Your credit card is smoking! Put it in rice!",
        "🎮 For that money, you could've bought a PlayStation! Priorities!",
        "📱 That's the new iPhone. Steve Jobs is rolling in his grave!",
        "💍 That's an engagement ring... for your money?",
        "🚗 That's a beater car. At least you can drive to the bank... oh wait!",
        "🏥 That's a medical bill. Your health is priceless (but apparently not)!",
        "🎓 That's a semester of college. Student loans called, they want to talk!",
        "🏠 That's 1 month's rent in some cities. Hope you like roommates!",
        "🐕 That's a purebred puppy. Who's a good boy? Not your bank account!",
      ];
    } else if (amount < 5000) {
      return [
        "🔥 \$${amount.toStringAsFixed(2)}! You're not broke, you're financially ✨adventurous✨!",
        "💀 Your bank account just needed CPR! Call 911!",
        "🏦 The bank manager is personally coming to your house!",
        "😭 You spent WHAT?! Your future self is crying right now!",
        "🚨 THIS IS NOT A DRILL! Your wallet has left the chat!",
        "🎉 Congratulations! You've been promoted to 'Professional Spender'!",
        "💸 Your money: 'I must go, my planet needs me' *poof*",
        "🤡 And they said money can't buy happiness... look at you go!",
        "🚗 That's a down payment on a car. Vroom vroom to poverty!",
        "💍 That's an actual wedding ring. Congratulations on your marriage to debt!",
        "✈️ That's a vacation to Europe. Don't forget to save money for... oh wait!",
        "🖥️ That's a gaming PC. Your frames will be high, your bank account low!",
        "🏍️ That's a motorcycle. At least you'll look cool being broke!",
      ];
    } else {
      return [
        "💀 \$${amount.toStringAsFixed(2)}?! The IRS just added you to their Christmas card list!",
        "🏦 Your bank account just called 911... on YOU!",
        "😱 Elon Musk just felt a disturbance in his bank account!",
        "🚨 The Federal Reserve is printing money just to cover your expenses!",
        "💸 Money: 'I'm leaving you. It's not me, it's your spending habits!'",
        "🏠 That's a down payment on a house. You bought a... what?",
        "🎓 That's a college degree. At least you'll be educated in poverty!",
        "🚗 That's a NEW CAR! Your driveway is nicer than your kitchen now!",
        "💍 That's a luxury wedding. Here comes the bride, there goes your savings!",
        "✈️ That's a trip around the world. Take pictures, you'll need memories when broke!",
        "🖼️ That's actual art. The starving artist thanks you (now you're both starving)!",
        "⚓ That's a boat! The two best days? The day you buy it AND the day you sell it!",
        "🐴 That's a horse. What are you, a cowboy? Yeehaw to debt!",
        "🎰 You could've gone to Vegas and lost it there. At least you'd have a story!",
      ];
    }
  }
  
  static String getFunnySavingTip() {
    final tips = [
      "💡 Pro tip: Eating instant noodles for a week builds character! And saves money!",
      "💡 Fun fact: Plants need water to grow, not new shoes!",
      "💡 Your future self is judging your current spending!",
      "💡 Remember: A bargain is something you don't need at a price you can't resist!",
      "💡 You're not broke, you're just pre-rich! (That's not a thing, I'm sorry)",
      "💡 The best things in life are free... like downloading this app!",
      "💡 Skip one coffee a day and you'll save \$1000 a year! (Do the math, then cry)",
      "💡 If you can't buy it twice, you can't afford it. Unless it's rent. Then you're screwed.",
      "💡 Money can't buy happiness, but it can buy tacos. That's basically the same thing!",
      "💡 The lottery is a tax on people who are bad at math. So is your spending!",
      "💡 Save money: turn off the lights. Read by candlelight. Become a Victorian ghost!",
      "💡 Eating out? More like eating your savings!",
      "💡 Your wallet called. It wants to see other people.",
      "💡 Think before you spend. Then don't spend. You're welcome!",
      "💡 A penny saved is a penny... actually just spend it, inflation is crazy!",
    ];
    return tips[_random.nextInt(tips.length)];
  }
  
  static String getMemeForIncome(double amount) {
    final memes = [
      "🤑 \$${amount.toStringAsFixed(2)}? Look at Mr./Ms. Moneybags over here!",
      "💰 Your bank account just did a happy dance!",
      "🎉 Congratulations! You're slightly less broke!",
      "💪 Treat yo' self! (But maybe save some too)",
      "🦄 Rare sighting: Money actually COMING IN!",
      "✨ Manifestation works! Now do it again!",
      "💸 Reverse uno! Money came to YOU this time!",
      "🎊 Party at your place? Oh wait, you just got paid!",
      "💃 That's the sound of your wallet un-crying!",
      "🍾 Pop the champagne! ...Actually buy the cheap stuff, save the rest!",
      "📈 Your bank account is trending upward! This is not financial advice!",
      "🦸‍♂️ Look who's adulting correctly!",
      "🌈 Every dollar counts! Except the ones you're about to spend...",
      "💪 Financial fitness level: Getting there!",
      "🎯 Bullseye! You hit your target. Now don't move the target!",
      "🕺 Money, money, money! Must be funny, in a rich man's world!",
      "🤴 You dropped this 👑 Keep grinding!",
      "🌟 Look at you, making responsible choices! Who are you?",
    ];
    return memes[_random.nextInt(memes.length)];
  }
  
  static String getMemeForBalance(double balance) {
    if (balance < 0) {
      final negativeMemes = [
        "⚠️ NEGATIVE BALANCE ALERT! Your wallet is filing for bankruptcy! ⚠️",
        "💀 Congratulations! You're now sponsored by 'Being Broke'!",
        "🏦 The bank just sent you a 'Get Well Soon' card!",
        "😭 Your money situation: 'It's complicated' on Facebook",
        "🚨 Red alert! Your bank account is in the danger zone!",
        "📉 That's not a balance, that's a tragedy in numbers!",
        "💸 Your money: 'Gone with the wind' literally!",
        "🎪 Your finances are now a circus! Welcome to the show!",
        "🔥 Everything is fine. (It's not fine, but we pretend!)",
      ];
      return negativeMemes[_random.nextInt(negativeMemes.length)];
    } else if (balance < 100) {
      final lowMemes = [
        "😬 Living dangerously close to broke! One coffee away from disaster!",
        "💪 You've got this! (Maybe don't check your balance again today)",
        "🍞 Rice and beans diet incoming! But you'll survive!",
        "🎯 Broke but still standing! That's called character building!",
        "💰 Money is like soap: the more you have, the more you lose. Wait...",
        "🕯️ Your financial light is flickering! Add more income!",
      ];
      return lowMemes[_random.nextInt(lowMemes.length)];
    } else if (balance < 500) {
      final mediumMemes = [
        "👍 You're surviving! Not thriving, but surviving!",
        "💪 Slowly but surely! Like a turtle winning the race!",
        "🌱 Your money plant is growing! Water it with more income!",
        "📈 The line is going up! (Slowly, but up is up!)",
        "🎯 You're in the yellow zone. One good week away from green!",
      ];
      return mediumMemes[_random.nextInt(mediumMemes.length)];
    } else if (balance < 1000) {
      final goodMemes = [
        "💪 Look at you! Actually being responsible! Who are you and what did you do with the old you?",
        "🌟 Financial glow-up in progress!",
        "🦄 You have savings? Are you a mythical creature?",
        "🎉 Adulting level: Intermediate!",
        "💪 Your wallet is getting swole! Keep pumping those savings!",
        "🏆 Bronze medal in finance! Silver and gold are next!",
      ];
      return goodMemes[_random.nextInt(goodMemes.length)];
    } else {
      final richMemes = [
        "🤑 FLEX ALERT! Someone's adulting correctly! Teach me your ways!",
        "💰 Your savings account just flexed on everyone!",
        "🌟 Legendary financial status unlocked!",
        "🎮 Achievement: 'Moneybags' earned! +100 respect!",
        "💪 Your wallet has muscles now! Don't let it get too cocky!",
        "🏆 Platinum trophy in personal finance! You've beaten the game!",
        "🦄 You're a financial unicorn! Do you even exist?",
        "✨ Manifestation level: MASTER. Share your secrets!",
        "🎉 Party at YOUR place! Because YOU have money!",
        "👑 King/Queen of budgeting! The crown is yours!",
      ];
      return richMemes[_random.nextInt(richMemes.length)];
    }
  }
  
  // New: Combined memes for specific categories
  static String getMemeForSpecificExpense(String title, double amount) {
    final lowerTitle = title.toLowerCase();
    
    if (lowerTitle.contains("coffee") || lowerTitle.contains("starbucks")) {
      final coffeeMemes = [
        "☕ That's a lot of coffee! Are you trying to become caffeine?",
        "💸 Starbucks called, they want to thank you for their new pool!",
        "😵 That's enough caffeine to fuel a small horse!",
        "📊 Fun fact: Skip 100 coffees, buy a PlayStation. Choose wisely!",
      ];
      return coffeeMemes[_random.nextInt(coffeeMemes.length)];
    }
    
    if (lowerTitle.contains("food") || lowerTitle.contains("restaurant") || lowerTitle.contains("pizza")) {
      final foodMemes = [
        "🍕 The fridge called, it feels neglected!",
        "💸 Your stomach is happy, your wallet is not!",
        "🍔 That's a lot of burgers! Ronald McDonald sends his regards!",
        "😋 Was it worth it? (Spoiler: Probably yes, but we'll never admit it)",
      ];
      return foodMemes[_random.nextInt(foodMemes.length)];
    }
    
    if (lowerTitle.contains("game") || lowerTitle.contains("playstation") || lowerTitle.contains("xbox")) {
      final gameMemes = [
        "🎮 Congratulations! You've purchased a time-sink!",
        "💀 Say goodbye to productivity! Hello to 3 AM gaming!",
        "🎯 Achievement unlocked: 'Broke but Entertained'!",
        "🕹️ Your social life just left the chat!",
      ];
      return gameMemes[_random.nextInt(gameMemes.length)];
    }
    
    if (lowerTitle.contains("amazon") || lowerTitle.contains("shopping")) {
      final shoppingMemes = [
        "📦 Jeff Bezos thanks you for his next rocket ship!",
        "💸 One click? More like one financial mistake!",
        "🎁 Amazon Prime: Fast shipping, slow savings!",
        "📦 Your packages are coming! Your money? Not so much!",
      ];
      return shoppingMemes[_random.nextInt(shoppingMemes.length)];
    }
    
    // Return regular meme if no category matches
    return getMemeForExpense(amount, title);
  }
}
