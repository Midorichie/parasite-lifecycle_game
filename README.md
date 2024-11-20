# Parasite Life Cycle Educational Game 🦠

An interactive educational game that teaches students about parasite life cycles while earning blockchain rewards for learning achievements.

## 🎮 Overview

This educational game combines biological science with blockchain technology to create an engaging learning experience about parasite life cycles. Players guide different parasites through their life stages while learning about their biology and earning rewards for their progress.

### Key Features

- Multiple parasite lifecycles (Plasmodium, Tapeworm)
- Interactive animations and visual representations
- Educational quiz system
- Blockchain-based reward system using Stacks
- Achievement tracking
- Sound effects and visual feedback
- Detailed biological information for each stage

## 🛠️ Technologies Used

- Python 3.8+
- Pygame
- Stacks Blockchain
- Web3.py
- OpenCV
- NumPy
- Asyncio

## 📋 Prerequisites

Before running the game, ensure you have the following installed:
- Python 3.8 or higher
- pip (Python package manager)
- Git

## 🚀 Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/parasite-lifecycle-game.git
cd parasite-lifecycle-game
```

2. Create and activate a virtual environment (recommended):
```bash
python -m venv venv
# On Windows
venv\Scripts\activate
# On macOS/Linux
source venv/bin/activate
```

3. Install required packages:
```bash
pip install -r requirements.txt
```

## 📁 Project Structure

```
parasite-lifecycle-game/
├── assets/
│   ├── images/
│   │   ├── sporozoite.png
│   │   ├── liver_stage.png
│   │   └── ...
│   ├── sounds/
│   │   ├── success.wav
│   │   ├── failure.wav
│   │   └── achievement.wav
├── src/
│   ├── __init__.py
│   ├── game.py
│   ├── parasites.py
│   ├── blockchain.py
│   └── ui.py
├── requirements.txt
├── README.md
└── LICENSE
```

## 🎮 How to Play

1. Start the game:
```bash
python src/game.py
```

2. Select a parasite to study
3. Guide the parasite through its life cycle stages
4. Complete quizzes to earn points and rewards
5. Achieve milestones to earn blockchain tokens

### Game Controls

- Mouse Click: Interact with game elements
- Space: Pause/Resume game
- ESC: Return to main menu
- Q: Quit game

## 🔗 Blockchain Integration

### Setting Up Your Wallet

1. Create a Stacks wallet if you don't have one
2. Configure your wallet address in the game:
   - Open `src/blockchain.py`
   - Update `STACKS_CONFIG` with your wallet information

### Rewards System

- Complete life cycles: 100 tokens
- Answer quiz correctly: 10 tokens
- Achieve milestones: 50 tokens
- Daily learning streak: 25 tokens

## 🛠️ Development

### Adding New Parasites

1. Create a new class inheriting from `Parasite` base class
2. Implement required lifecycle stages
3. Add sprite assets
4. Register in `parasites.py`

Example:
```python
class NewParasite(Parasite):
    def get_lifecycle(self):
        return {
            "stage1": ParasiteStage(
                name="Stage 1",
                description="Description",
                duration=30,
                required_conditions=["condition1"],
                next_stages=["stage2"],
                points=10,
                sprite="assets/stage1.png",
                quiz_questions=[...]
            ),
            # Add more stages...
        }

    def get_difficulty(self):
        return 1
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/NewFeature`
3. Commit changes: `git commit -am 'Add NewFeature'`
4. Push to branch: `git push origin feature/NewFeature`
5. Submit a Pull Request

## 📝 Testing

Run the test suite:
```bash
python -m pytest tests/
```

## 🐛 Known Issues

- Blockchain transactions may be slow during network congestion
- Some animations might flicker on slower systems
- Sound delay on certain Windows configurations

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- Initial Work - [Your Name]
- Contributors - See [CONTRIBUTORS.md](CONTRIBUTORS.md)

## 🙏 Acknowledgments

- Pygame Community
- Stacks Blockchain Team
- Educational Biology Resources
- Open Source Contributors

## 📞 Support

For support, please:
1. Check the [Issues](https://github.com/yourusername/parasite-lifecycle-game/issues) page
2. Join our [Discord Community](https://discord.gg/yourserver)
3. Email: support@yourproject.com

## 🔄 Version History

- v2.0.0 (Current)
  - Added blockchain integration
  - Multiple parasite support
  - Enhanced graphics and sound
  - Achievement system

- v1.0.0
  - Initial release
  - Basic game mechanics
  - Single parasite lifecycle